import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/tts_service.dart';

part 'tts_state.dart';

class TtsCubit extends Cubit<TtsState> {
  final TtsService ttsService;

  TtsCubit({required this.ttsService}) : super(TtsState());

  void handlePlay(String text) async {
    log('Playing audio.');
    await ttsService.stopReading();
    try {
      final result = await ttsService.readText(text);
      if (result == 1) {
        state.pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        emit(state.copyWith(shouldAutoPlay: true));
      }
    } catch (e, stk) {
      log('TTS Failure: ', error: e, stackTrace: stk);
    }
  }

  void stop() async {
    emit(state.copyWith(shouldAutoPlay: false));
    log("Stopping audio");
    await ttsService.stopReading();
  }
}
