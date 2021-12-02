part of 'channel_bloc.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object> get props => [];
}

class GetChannelEvent extends ChannelEvent {}

class GetNewsByChannelEvent extends ChannelEvent {
  const GetNewsByChannelEvent({
    required this.channelName,
  });
  final String channelName;
}

class LikeNewsChannelEvent extends ChannelEvent {
  final News likedNews;

  const LikeNewsChannelEvent({
    required this.likedNews,
  });
}

class UnlikeNewsChannelEvent extends ChannelEvent {
  final News unlikedNews;

  const UnlikeNewsChannelEvent({
    required this.unlikedNews,
  });
}

class AddCommentChannelEvent extends ChannelEvent {
  final CommentModel comment;
  final News news;

  const AddCommentChannelEvent({required this.comment, required this.news});
}
