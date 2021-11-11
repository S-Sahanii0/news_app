part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoadingSuccess extends NewsState {
  final List<News> newsList;

  const NewsLoadingSuccess({required this.newsList});

  @override
  List<Object> get props => [newsList];
}

class NewsLoadingFailure extends NewsState {}
