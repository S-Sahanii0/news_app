part of 'tts_cubit.dart';

class TtsState {
  TtsState({this.shouldAutoPlay = false});

  final PageController pageController = PageController();
  final bool shouldAutoPlay;

  TtsState copyWith({
    bool? shouldAutoPlay,
  }) {
    return TtsState(
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