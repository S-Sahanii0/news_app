import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_app/features/news_feed/services/tts_repository.dart';

class TtsService implements TtsRepository {
  TtsService({required this.flutterTts}) {
    _setUpTTS();
  }

  final FlutterTts flutterTts;

  @override
  Future<int> readText(String text) async {
    final result = await flutterTts.speak(text);
    return result;
  }

  @override
  Future<void> stopReading() async {
    await flutterTts.stop();
  }

  // Future readAndComplete(String text) async{
  //   await flutterTts.speak(text);
  //   return flutterTts.awaitSpeakCompletion(true);
  // }

  Future<void> _setUpTTS() async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setSharedInstance(true);
    await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(0.5);
    await flutterTts.setPitch(0.5);
  }
}
