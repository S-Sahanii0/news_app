part of 'channel_bloc.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object> get props => [];
}

class GetChannelEvent extends ChannelEvent {}

class GetNewsByChannelEvent extends ChannelEvent {
  const GetNewsByChannelEvent({required this.channelName});
  final String channelName;
}
