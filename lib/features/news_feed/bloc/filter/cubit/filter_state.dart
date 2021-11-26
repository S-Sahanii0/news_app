part of 'filter_cubit.dart';

abstract class FilterState extends Equatable {
  const FilterState();
}

class FilterInitailState extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterLoadInProgress extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterFailure extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterLoadSuccess extends FilterState {
  const FilterLoadSuccess(
      {required this.filterType, required this.news, this.hasReachedMax = false});

  final FilterType filterType;
  final List<News> news;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [filterType, news];
}

enum FilterType { read, unread, all }
