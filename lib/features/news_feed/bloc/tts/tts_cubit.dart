import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/tts_service.dart';

part 'tts_state.dart';

class TtsCubit extends Cubit<TtsState> {
  final TtsService ttsService;
  late final PageController pageController;

  TtsCubit({required this.ttsService}) : super(TtsState());

  void init(int index) {
    pageController = PageController(initialPage: index);
    emit(state.copyWith(pageController: pageController));
  }

  void handlePlay(String text) async {
    log('Playing audio.');
    final result = await ttsService.readText(text);
    if (result == 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      emit(state.copyWith(shouldAutoPlay: true));
    }
  }

  void stop() async {
    log("Stopping audio");
    await ttsService.stopReading();
  }
}
