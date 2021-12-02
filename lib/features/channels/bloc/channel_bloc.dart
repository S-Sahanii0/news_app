import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/channels/models/channel_model.dart';
import 'package:news_app/features/channels/services/channel_service.dart';
import 'package:news_app/features/news_feed/model/comment_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final NewsService newsService;
  final ChannelService channelService;
  ChannelBloc({
    required this.channelService,
    required this.newsService,
  }) : super(ChannelInitial()) {
    on<GetChannelEvent>(_handleGetChannelEvent);
    on<GetNewsByChannelEvent>(_handleGetNewsByChannelEvent);
    on<LikeNewsChannelEvent>(_handleLikeNewsByChannelEvent);
    on<UnlikeNewsChannelEvent>(_handleUnLikeNewsByChannel);
    on<AddCommentChannelEvent>(_handleCommentChannelNewsByChannel);
  }

  _handleGetChannelEvent(
      GetChannelEvent event, Emitter<ChannelState> emit) async {
    try {
      emit(ChannelLoading());
      final result = await channelService.getChannelList();
      emit(ChannelLoadSuccess(
          otherChannels: result, likedChannels: const [], news: const []));
    } catch (e) {
      emit(ChannelLoadFailure());
    }
  }

  _handleLikeNewsByChannelEvent(
      LikeNewsChannelEvent event, Emitter<ChannelState> emit) async {
    final currentState = (state as ChannelLoadSuccess);

    try {
      await newsService.updateLike(event.likedNews.id!);
      final updatedList = List<News>.from(currentState.news
          .map((element) =>
              element.id == event.likedNews.id ? event.likedNews : element)
          .toList());
      emit(ChannelLoadSuccess(
          news: updatedList,
          likedChannels: const [], //Required if decided to follow channels in future
          otherChannels: currentState.otherChannels));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      emit(ChannelLoadFailure());
    }
  }

  _handleUnLikeNewsByChannel(
      UnlikeNewsChannelEvent event, Emitter<ChannelState> emit) async {
    final currentState = (state as ChannelLoadSuccess);

    try {
      await newsService.updateLike(event.unlikedNews.id!);
      final updatedList = List<News>.from(currentState.news
          .map((element) =>
              element.id == event.unlikedNews.id ? event.unlikedNews : element)
          .toList());
      emit(ChannelLoadSuccess(
          news: updatedList,
          likedChannels: const [], //Required if decided to follow channels in future
          otherChannels: currentState.otherChannels));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      emit(ChannelLoadFailure());
    }
  }

  _handleCommentChannelNewsByChannel(
      AddCommentChannelEvent event, Emitter<ChannelState> emit) async {
    final currentState = (state as ChannelLoadSuccess);

    try {
      await newsService.addComments(event.comment, event.news.id!);
      final updatedList = List<News>.from(currentState.news
          .map((element) =>
              element.id == event.news.id ? event.news.copyWith() : element)
          .toList());
      emit(ChannelLoadSuccess(
          news: updatedList,
          likedChannels: [],
          otherChannels: currentState.otherChannels));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      emit(ChannelLoadFailure());
    }
  }

  _handleGetNewsByChannelEvent(
      GetNewsByChannelEvent event, Emitter<ChannelState> emit) async {
    final currentChannelList = (state as ChannelLoadSuccess).otherChannels;
    try {
      emit(ChannelLoading());
      final result = await channelService.getNewsByChannel(event.channelName);
      emit(ChannelLoadSuccess(
          otherChannels: currentChannelList, likedChannels: [], news: result));
    } catch (e) {
      emit(ChannelLoadFailure());
    }
  }
}
