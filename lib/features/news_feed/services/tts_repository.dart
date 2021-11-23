abstract class TtsRepository {
  Future<int> readText(String text);
  Future<void> stopReading();
}
