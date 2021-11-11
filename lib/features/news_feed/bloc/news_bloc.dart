import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _newsService = NewsService();
  NewsBloc() : super(NewsInitial()) {
    on<GetNewsEvent>((event, emit) async {
      try {
        final newsList = await _newsService.getAllNews();
        emit(NewsLoading());
        emit(NewsLoadingSuccess(newsList: newsList));
      } catch (e) {
        emit(NewsLoadingFailure());
      }
    });
  }
}
