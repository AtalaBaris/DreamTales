import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/injection/injection.dart';
import '../../../audio_player/domain/services/text_to_speech_service.dart';

/// Masal detay sayfası - Tam sayfa görünüm
class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  final String title;
  final String imageUrl;
  final String content;

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late final TextToSpeechService _ttsService;
  StreamSubscription<TtsState>? _stateSubscription;
  
  bool _isPlaying = false;
  double _playbackSpeed = 1.0; // Slider değeri: 1.0x = normal hız
  String _selectedVoice = 'Kadın';

  /// Cümle cümle seslendirme için
  List<String> _sentences = [];
  int _currentReadingIndex = -1;
  bool _userStopped = false;
  bool _sentenceBySentence = false;

  @override
  void initState() {
    super.initState();
    _ttsService = getIt<TextToSpeechService>();
    _sentences = _splitIntoSentences(widget.content);
    
    // TTS state'i dinle
    _stateSubscription = _ttsService.stateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == TtsState.playing;
      });
      // Cümle bittiğinde sıradaki cümleyi oku (kullanıcı durdurmadıysa)
      if (state == TtsState.stopped && _sentenceBySentence && !_userStopped && mounted) {
        _playNextSentence();
      }
    });

    // İlk hız ayarını yap: slider 1.0x -> flutter_tts 0.5 (normal hız)
    _updateSpeechRate(_playbackSpeed);
  }

  /// Metni cümlelere böl (. ! ? sonrası boşluk veya satır sonu)
  static List<String> _splitIntoSentences(String text) {
    if (text.trim().isEmpty) return [];
    final trimmed = text.trim();
    final parts = trimmed.split(RegExp(r'(?<=[.!?])\s+'));
    final list = parts.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    return list.isEmpty ? [trimmed] : list;
  }

  /// Sıradaki cümleyi seslendir
  Future<void> _playNextSentence() async {
    if (!mounted) return;
    _currentReadingIndex++;
    if (_currentReadingIndex >= _sentences.length) {
      setState(() {
        _sentenceBySentence = false;
        _currentReadingIndex = -1;
      });
      return;
    }
    setState(() {});
    await _ttsService.speak(_sentences[_currentReadingIndex]);
  }

  /// Slider değerini (0.5-2.0) flutter_tts rate'e (0.25-1.0) çevir
  /// 0.5x -> 0.25, 1.0x -> 0.5, 2.0x -> 1.0
  Future<void> _updateSpeechRate(double sliderValue) async {
    final mappedRate = sliderValue * 0.5; // 0.5x-2.0x -> 0.25-1.0
    await _ttsService.setSpeechRate(mappedRate.clamp(0.25, 1.0));
    
    // Eğer oynatılıyorsa, hız değişikliğinin uygulanması için durdurup tekrar başlat
    if (_isPlaying && _ttsService.currentState == TtsState.playing) {
      await _ttsService.stop();
      _userStopped = true;
      await Future.delayed(const Duration(milliseconds: 100));
      _userStopped = false;
      _sentenceBySentence = true;
      _currentReadingIndex = -1;
      _playNextSentence();
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _handlePlayPause() async {
    if (_isPlaying) {
      await _ttsService.pause();
    } else {
      _userStopped = false;
      if (_ttsService.currentState == TtsState.paused) {
        // Duraklatılmıştı, aynı cümleden devam et
        if (_currentReadingIndex >= 0 && _currentReadingIndex < _sentences.length) {
          await _ttsService.speak(_sentences[_currentReadingIndex]);
        }
      } else {
        // Durdurulmuştu, cümle cümle baştan başlat
        _sentenceBySentence = true;
        _currentReadingIndex = -1;
        _playNextSentence();
      }
    }
  }

  Future<void> _handleSpeedChanged(double speed) async {
    // Değeri 0.1x adımlarla yuvarla (örn: 1.77 -> 1.8)
    final roundedSpeed = (speed * 10).round() / 10.0;
    setState(() => _playbackSpeed = roundedSpeed);
    // Hız değişikliğini uygula (oynatma sırasında da çalışır)
    await _updateSpeechRate(roundedSpeed);
  }

  Future<void> _handleVoiceChanged(String voice) async {
    setState(() => _selectedVoice = voice);
    // Ses tonu değişikliği için pitch ayarı
    // Kadın: 1.3 (daha yüksek), Erkek: 0.6 (daha alçak - daha erkek gibi)
    double pitch = 1.0;
    switch (voice) {
      case 'Kadın':
        pitch = 1.3;
        break;
      case 'Erkek':
        pitch = 0.6; // Daha düşük pitch = daha erkek sesi
        break;
    }
    await _ttsService.setPitch(pitch);
    
    // Eğer oynatılıyorsa, ses tonu değişikliğinin uygulanması için durdurup tekrar başlat
    if (_isPlaying && _ttsService.currentState == TtsState.playing) {
      await _ttsService.stop();
      _userStopped = true;
      await Future.delayed(const Duration(milliseconds: 100));
      _userStopped = false;
      _sentenceBySentence = true;
      _currentReadingIndex = -1;
      _playNextSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Üstte görsel - AppBar ile birlikte
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () {
                _userStopped = true;
                _ttsService.stop();
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // İçerik
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dinleme kontrolleri
                  _AudioControls(
                    isPlaying: _isPlaying,
                    playbackSpeed: _playbackSpeed,
                    selectedVoice: _selectedVoice,
                    onPlayPause: _handlePlayPause,
                    onSpeedChanged: _handleSpeedChanged,
                    onVoiceChanged: _handleVoiceChanged,
                  ),
                  const SizedBox(height: 24),
                  // Masal metni - cümle cümle, okunan cümle vurgulu (smooth renk geçişi)
                  _HighlightedStoryText(
                    sentences: _sentences,
                    currentReadingIndex: _currentReadingIndex,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Masal metnini cümle cümle gösterir; okunan cümle smooth renk geçişiyle vurgulanır
class _HighlightedStoryText extends StatelessWidget {
  const _HighlightedStoryText({
    required this.sentences,
    required this.currentReadingIndex,
  });

  final List<String> sentences;
  final int currentReadingIndex;

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) {
      return const Text(
        '',
        style: TextStyle(
          fontSize: 17,
          height: 1.7,
          color: AppColors.textPrimary,
          letterSpacing: 0.3,
        ),
      );
    }
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: sentences.asMap().entries.map((entry) {
        final index = entry.key;
        final sentence = entry.value;
        final isReading = index == currentReadingIndex;
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          style: TextStyle(
            fontSize: 17,
            height: 1.7,
            color: isReading ? AppColors.secondary : AppColors.textPrimary,
            letterSpacing: 0.3,
            fontWeight: isReading ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(sentence + (index < sentences.length - 1 ? ' ' : '')),
        );
      }).toList(),
    );
  }
}

class _AudioControls extends StatelessWidget {
  const _AudioControls({
    required this.isPlaying,
    required this.playbackSpeed,
    required this.selectedVoice,
    required this.onPlayPause,
    required this.onSpeedChanged,
    required this.onVoiceChanged,
  });

  final bool isPlaying;
  final double playbackSpeed;
  final String selectedVoice;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<String> onVoiceChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dinleme butonu
          Center(
            child: GestureDetector(
              onTap: onPlayPause,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 36,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Ses hızı ayarı
          Row(
            children: [
              const Icon(Icons.speed_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Hız',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${playbackSpeed.toStringAsFixed(1)}x',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: playbackSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15, // Daha hassas ayar için (0.1x adımlarla)
            activeColor: AppColors.secondary,
            inactiveColor: AppColors.textTertiary,
            onChanged: onSpeedChanged,
          ),
          const SizedBox(height: 20),
          // Ses tonu seçimi
          Row(
            children: [
              const Icon(Icons.record_voice_over_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Ses Tonu',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: selectedVoice,
                dropdownColor: AppColors.surface,
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textSecondary),
                items: const [
                  DropdownMenuItem(
                    value: 'Kadın',
                    child: Text('Kadın', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Erkek',
                    child: Text('Erkek', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) onVoiceChanged(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
