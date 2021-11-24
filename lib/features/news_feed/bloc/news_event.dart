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

class UnlikeNewsEvent extends NewsEvent {
  final News unlikedNews;

  const UnlikeNewsEvent({
    required this.unlikedNews,
  });
}

class AddCommentEvent extends NewsEvent {
  final CommentModel comment;
  final News news;

  const AddCommentEvent({required this.comment, required this.news});
}
