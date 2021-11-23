part of 'tts_cubit.dart';

class TtsState {
  TtsState({this.shouldAutoPlay = false, this.pageController});

  final PageController? pageController;
  final bool shouldAutoPlay;

  TtsState copyWith({
    PageController? pageController,
    bool? shouldAutoPlay,
  }) {
    return TtsState(
      pageController: pageController ?? this.pageController,
      shouldAutoPlay: shouldAutoPlay ?? this.shouldAutoPlay,
    );
  }
}
// / abstract class TtsState extends Equatable {}


// class TtsPlayingState extends TtsState {
//   @override
//   List<Object> get props => [];
// }

// class TtsStoppedState extends TtsState {

//   @override
//   List<Object> get props => [];
// }