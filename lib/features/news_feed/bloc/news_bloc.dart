import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/news_feed/model/comment_model.dart';
import '../model/news_model.dart';
import '../services/news_service.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;

  // to remove & refactor later
  List<News> _newsList = [];
  NewsBloc({required this.newsService}) : super(NewsInitial()) {
    on<GetFirstNewsListEvent>((event, emit) async {
      emit(NewsLoading());

      try {
        await for (var news in newsService
            .getFirstNewsList(event.user?.chosenCategories ?? [])) {
          _newsList = List.from(news);
          emit(NewsLoadingSuccess(newsList: _newsList));
        }
      } catch (e, stk) {
        log(e.toString());
        log(stk.toString());
        emit(NewsLoadingFailure());
      }
    });
    on<GetNextNewsListEvent>((event, emit) async {
      try {
        // emit(NewsLoading());
        await for (var news in await newsService.getNextNewsList()) {
          _newsList = List.from(news);
          emit(NewsLoadingSuccess(
              newsList: _newsList, hasReachedMax: _newsList.isEmpty));
        }
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
    on<LikeNewsEvent>((event, emit) async {
      final currentState = (state as NewsLoadingSuccess).newsList;

      try {
        log("Like event triggered");
        final updatedNews = await newsService.updateLike(event.likedNews.id!);
        final updatedList = List<News>.from(currentState
            .map((element) =>
                element.id == event.likedNews.id ? event.likedNews : element)
            .toList());
        emit(NewsLoadingSuccess(newsList: updatedList));
      } catch (e, stk) {
        log(e.toString(), stackTrace: stk);
        emit(NewsLoadingFailure());
      }
    });

    on<UnlikeNewsEvent>((event, emit) async {
      log("unlike event triggered");
      final currentState = (state as NewsLoadingSuccess).newsList;

      try {
        final updatedNews = await newsService.unlikeNews(event.unlikedNews.id!);
        final updatedList = List<News>.from(currentState
            .map((element) => element.id == event.unlikedNews.id
                ? event.unlikedNews
                : element)
            .toList());
        emit(NewsLoadingSuccess(newsList: updatedList));
      } catch (e, stk) {
        log(e.toString(), stackTrace: stk);
        emit(NewsLoadingFailure());
      }
    });

    on<AddCommentEvent>((event, emit) async {
      final currentState = (state as NewsLoadingSuccess).newsList;

      try {
        await newsService.addComments(event.comment, event.news.id!);
        final updatedList = List<News>.from(currentState
            .map((element) =>
                element.id == event.news.id ? event.news.copyWith() : element)
            .toList());
        emit(NewsLoadingSuccess(newsList: updatedList));
      } catch (e, stk) {
        log(e.toString(), stackTrace: stk);
        emit(NewsLoadingFailure());
      }
    });

    on<SortNewsEvent>((event, emit) async {
      final currentState = (state as NewsLoadingSuccess).newsList;
      emit(NewsLoading());
      try {
        final listByDate = List<News>.from(currentState)
          ..sort((a, b) => event.isAscending
              ? a.date.compareTo(b.date)
              : b.date.compareTo(a.date));
        emit(NewsLoadingSuccess(newsList: listByDate));
      } catch (e, stk) {
        log(e.toString(), stackTrace: stk);
        emit(NewsLoadingFailure());
      }
    });
  }
}
