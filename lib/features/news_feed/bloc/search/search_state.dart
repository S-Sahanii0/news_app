part of 'search_cubit.dart';

abstract class SearchState extends Equatable {}

class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchError extends SearchState {
  SearchError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchEmpty extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {
  SearchLoaded(this.newsList);

  final List<News> newsList;
  @override
  List<Object?> get props => [newsList];
}
