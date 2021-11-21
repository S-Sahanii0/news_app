import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/news_model.dart';
import '../services/news_service.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;
  List<News> _newsList = [];
  NewsBloc({required this.newsService}) : super(NewsInitial()) {
    on<GetFirstNewsListEvent>((event, emit) async {
      emit(NewsLoading());

      try {
        await for (var news in newsService.getFirstNewsList()) {
          _newsList = List.from(news);
          emit(NewsLoadingSuccess(newsList: _newsList));
        }
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<GetNextNewsListEvent>((event, emit) async {
      try {
        // emit(NewsLoading());
        await for (var news in await newsService.getNextNewsList()) {
          _newsList = List.from(news);
          emit(NewsLoadingSuccess(newsList: _newsList));
        }
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<BookMarkNewsEvent>((event, emit) async {
      try {
        print(_newsList.length);
        await newsService.addToBookmarks(event.newsToBookmark, event.uid);
        emit(NewsLoadingSuccess(newsList: _newsList));
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<RemoveBookMarkNewsEvent>((event, emit) async {
      try {
        await newsService.removeFromBookmarks(event.newsToBookmark, event.uid);
        emit(NewsLoadingSuccess(newsList: _newsList));
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<AddToHistory>((event, emit) async {
      try {
        await newsService.addToHistory(event.newsModel, event.uid);
        emit(NewsLoadingSuccess(newsList: _newsList));
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<RemoveFromHistory>((event, emit) async {
      try {
        await newsService.removeFromHistory(event.newsModel, event.uid);
        emit(NewsLoadingSuccess(newsList: _newsList));
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
  }
}
