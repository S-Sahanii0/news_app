import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.newsService}) : super(SearchInitial());

  final NewsService newsService;

  void onTextChanged(
    String query,
  ) async {
    if (query.isEmpty) return emit(SearchInitial());
    emit(SearchLoading());
    try {
      final results = newsService.newsList
        ..where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase())).toList();
      results.isEmpty ? emit(SearchEmpty()) : emit(SearchLoaded(results));
    } catch (error, stk) {
      log('Error when searching', error: error, stackTrace: stk);
      emit(SearchError('Something went wrong'));
    }
  }
}
