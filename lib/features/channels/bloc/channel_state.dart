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

  const ChannelLoadSuccess(
      {required this.otherChannels, required this.likedChannels});
}

class NewsByChannel extends ChannelState {
  final List<News> newsList;

  NewsByChannel({required this.newsList});
}

class ChannelLoadFailure extends ChannelState {}
