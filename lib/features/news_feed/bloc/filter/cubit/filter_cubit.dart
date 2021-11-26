// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';

import '../../news_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit({required this.newsBloc}) : super(FilterInitailState()) {
    newsSubscription = newsBloc.stream.listen((event) {
      if (event is NewsLoadingSuccess)
        emit(FilterLoadSuccess(
            filterType: FilterType.all,
            news: event.newsList,
            hasReachedMax: event.hasReachedMax));
      if (event is NewsInitial) emit(FilterInitailState());
      if (event is NewsLoadingFailure)
        emit(FilterFailure());
      else if (event is NewsLoading) emit(FilterLoadInProgress());
    });
  }

  final NewsBloc newsBloc;
  late StreamSubscription newsSubscription;

  void applyFilter(List<News> news, FilterType filter, List<News> history) {
    final filteredNews = news.where((news) {
      switch (filter) {
        case FilterType.read:
          return history.contains(news);
        // (val) => event.user.history!.any((element) => element.id == val.id)));
        case FilterType.unread:
          return !history.contains(news);
        default:
          return true;
      }
    });
    emit(FilterLoadSuccess(filterType: filter, news: filteredNews.toList()));
  }

  @override
  Future<void> close() {
    newsSubscription.cancel();
    return super.close();
  }
}
