import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/channels/models/channel_model.dart';
import 'package:news_app/features/channels/services/channel_service.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelService channelService;
  ChannelBloc({required this.channelService}) : super(ChannelInitial()) {
    on<GetChannelEvent>(_handleGetChannelEvent);
    on<GetNewsByChannelEvent>(_handleGetNewsByChannelEvent);
  }

  _handleGetChannelEvent(
      GetChannelEvent event, Emitter<ChannelState> emit) async {
    try {
      final result = await channelService.getChannelList();
      emit(ChannelLoadSuccess(otherChannels: result, likedChannels: []));
    } catch (e) {
      emit(ChannelLoadFailure());
    }
  }

  _handleGetNewsByChannelEvent(
      GetNewsByChannelEvent event, Emitter<ChannelState> emit) async {
    try {
      final result = await channelService.getNewsByChannel(event.channelName);
      emit(NewsByChannel(newsList: result));
    } catch (e) {
      emit(ChannelLoadFailure());
    }
  }
}
