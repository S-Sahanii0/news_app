part of 'channel_bloc.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();

  @override
  List<Object> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelLoadSuccess extends ChannelState {
  final List<Channel> otherChannels;
  final List<Channel> likedChannels;
  final List<News> news;

  const ChannelLoadSuccess({
    required this.otherChannels,
    required this.likedChannels,
    required this.news,
  });

  @override
  // TODO: implement props
  List<Object> get props => [otherChannels, likedChannels, news];
}

class NewsByChannel extends ChannelState {
  final List<News> newsList;

  NewsByChannel({required this.newsList});
}

class ChannelLoadFailure extends ChannelState {}
