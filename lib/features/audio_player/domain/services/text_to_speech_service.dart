/// TextToSpeechService - Domain katmanında TTS servis interface'i
/// 
/// Clean Architecture'da domain katmanı:
/// - Veri kaynağından bağımsızdır (flutter_tts, Google TTS, Azure TTS değişse bile aynı kalır)
/// - Business logic içermez, sadece contract tanımlar
/// - Sonra farklı TTS provider'ları kolayca değiştirilebilir
abstract class TextToSpeechService {
  /// Metni seslendir
  Future<void> speak(String text);

  /// Konuşmayı duraklat
  Future<void> pause();

  /// Konuşmayı durdur
  Future<void> stop();

  /// Konuşma hızını ayarla (0.0 - 1.0)
  Future<void> setSpeechRate(double rate);

  /// Konuşma tonunu ayarla (0.0 - 1.0)
  Future<void> setPitch(double pitch);

  /// Ses tonunu ayarla (örn: 'tr-TR', 'en-US')
  Future<void> setLanguage(String language);

  /// Ses tonunu ayarla (voice name veya locale)
  Future<void> setVoice(String voice);

  /// Mevcut ses tonlarını getir
  Future<List<String>> getAvailableVoices();

  /// Konuşma durumunu dinle (playing, paused, stopped)
  Stream<TtsState> get stateStream;

  /// Şu anki durum
  TtsState get currentState;
}

/// TTS durumları
enum TtsState {
  stopped,
  playing,
  paused,
}
