part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetFirstNewsListEvent extends NewsEvent {}

class GetNextNewsListEvent extends NewsEvent {}

class LikeNewsEvent extends NewsEvent {
  final News likedNews;

  const LikeNewsEvent({
    required this.likedNews,
  });
}

class RemoveBookMarkNewsEvent extends NewsEvent {
  final News newsToBookmark;
  final String uid;

  const RemoveBookMarkNewsEvent(
      {required this.newsToBookmark, required this.uid});
}

class AddToHistory extends NewsEvent {
  final News newsModel;
  final String uid;

  const AddToHistory({required this.newsModel, required this.uid});
}

class RemoveFromHistory extends NewsEvent {
  final News newsModel;
  final String uid;

  const RemoveFromHistory({required this.newsModel, required this.uid});
}
