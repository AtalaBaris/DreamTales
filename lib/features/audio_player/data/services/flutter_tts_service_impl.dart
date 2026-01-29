import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/services/text_to_speech_service.dart';

/// FlutterTtsServiceImpl - flutter_tts paketini kullanan implementasyon
/// 
/// Clean Architecture'da data katmanı:
/// - External library'leri kullanır (flutter_tts)
/// - Domain interface'ini implement eder
/// - Sonra başka bir TTS provider'a geçiş kolay olur
class FlutterTtsServiceImpl implements TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  final _stateController = StreamController<TtsState>.broadcast();
  TtsState _currentState = TtsState.stopped;

  FlutterTtsServiceImpl() {
    _init();
  }

  Future<void> _init() async {
    // Türkçe için varsayılan ayarlar
    await _flutterTts.setLanguage('tr-TR');
    // Varsayılan hız: 0.5 (normal hız, 1.0 çok hızlı)
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

    // Completion callback'leri
    _flutterTts.setCompletionHandler(() {
      _updateState(TtsState.stopped);
    });

    _flutterTts.setErrorHandler((msg) {
      _updateState(TtsState.stopped);
    });
  }

  void _updateState(TtsState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  @override
  Future<void> speak(String text) async {
    if (_currentState == TtsState.playing) {
      await stop();
    }
    await _flutterTts.speak(text);
    _updateState(TtsState.playing);
  }

  @override
  Future<void> pause() async {
    if (_currentState == TtsState.playing) {
      final result = await _flutterTts.pause();
      if (result == 1) {
        _updateState(TtsState.paused);
      }
    }
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
    _updateState(TtsState.stopped);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    // flutter_tts rate 0.0 - 1.0 arası
    await _flutterTts.setSpeechRate(rate.clamp(0.0, 1.0));
  }

  @override
  Future<void> setPitch(double pitch) async {
    // flutter_tts pitch 0.0 - 2.0 arası (1.0 normal)
    // Minimum 0.5 yerine 0.5 kullanıyoruz ama erkek sesi için 0.6 daha iyi
    await _flutterTts.setPitch(pitch.clamp(0.5, 2.0));
  }

  @override
  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  @override
  Future<void> setVoice(String voice) async {
    // flutter_tts'de voice ayarlamak için setVoice kullanılır
    // Voice formatı: "locale-voice" veya sadece voice name
    await _flutterTts.setVoice({'name': voice, 'locale': 'tr-TR'});
  }

  @override
  Future<List<String>> getAvailableVoices() async {
    final voices = await _flutterTts.getVoices;
    if (voices != null && voices is Map) {
      final List<dynamic>? voiceList = voices['voices'] as List<dynamic>?;
      if (voiceList != null) {
        return voiceList
            .map((v) => v['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      }
    }
    return [];
  }

  @override
  Stream<TtsState> get stateStream => _stateController.stream;

  @override
  TtsState get currentState => _currentState;

  /// Dispose - Stream'i kapat
  void dispose() {
    _stateController.close();
  }
}
