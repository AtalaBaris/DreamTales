import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/injection/injection.dart';
import '../../../audio_player/domain/services/text_to_speech_service.dart';

/// Masal detay sayfası - Hem Sesli Okuma Hem Modern Tasarım!
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
  double _playbackSpeed = 1.0; 
  String _selectedVoice = 'Kadın';

  List<String> _sentences = [];
  int _currentReadingIndex = -1;
  bool _userStopped = false;
  bool _sentenceBySentence = false;

  @override
  void initState() {
    super.initState();
    _ttsService = getIt<TextToSpeechService>();
    _sentences = _splitIntoSentences(widget.content);
    
    _stateSubscription = _ttsService.stateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == TtsState.playing;
      });
      if (state == TtsState.stopped && _sentenceBySentence && !_userStopped && mounted) {
        _playNextSentence();
      }
    });

    _updateSpeechRate(_playbackSpeed);
  }

  static List<String> _splitIntoSentences(String text) {
    if (text.trim().isEmpty) return [];
    final trimmed = text.trim();
    final parts = trimmed.split(RegExp(r'(?<=[.!?])\s+'));
    final list = parts.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    return list.isEmpty ? [trimmed] : list;
  }

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

  Future<void> _updateSpeechRate(double sliderValue) async {
    final mappedRate = sliderValue * 0.5; 
    await _ttsService.setSpeechRate(mappedRate.clamp(0.25, 1.0));
    
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
        if (_currentReadingIndex >= 0 && _currentReadingIndex < _sentences.length) {
          await _ttsService.speak(_sentences[_currentReadingIndex]);
        }
      } else {
        _sentenceBySentence = true;
        _currentReadingIndex = -1;
        _playNextSentence();
      }
    }
  }

  Future<void> _handleSpeedChanged(double speed) async {
    final roundedSpeed = (speed * 10).round() / 10.0;
    setState(() => _playbackSpeed = roundedSpeed);
    await _updateSpeechRate(roundedSpeed);
  }

  Future<void> _handleVoiceChanged(String voice) async {
    setState(() => _selectedVoice = voice);
    double pitch = 1.0;
    switch (voice) {
      case 'Kadın':
        pitch = 1.3;
        break;
      case 'Erkek':
        pitch = 0.6; 
        break;
    }
    await _ttsService.setPitch(pitch);
    
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
      backgroundColor: const Color(0xFFF8F9FA), // Göz yormayan uçuk gece arka planı
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. BÜYÜLÜ KAPAK FOTOĞRAFI (Kaydırdıkça esner)
          SliverAppBar(
            expandedHeight: 350.0,
            stretch: true,
            pinned: true,
            backgroundColor: const Color(0xFF9A67EA), 
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    _userStopped = true;
                    _ttsService.stop();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. MASAL İÇERİĞİ (Kitap sayfası hissi veren yuvarlak kağıt tasarımı)
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -40), 
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -10))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 40), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Etiketler
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0C3FC).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF9A67EA)),
                                const SizedBox(width: 8),
                                Text(
                                  'Gemini AI',
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF9A67EA)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC2E9FB).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.nightlight_round, size: 16, color: Color(0xFF4A90E2)),
                                const SizedBox(width: 8),
                                Text(
                                  'Uyku Masalı',
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A90E2)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      
                      // Senin o şahane Sesli Okuma Kontrol Panelin
                      _AudioControls(
                        isPlaying: _isPlaying,
                        playbackSpeed: _playbackSpeed,
                        selectedVoice: _selectedVoice,
                        onPlayPause: _handlePlayPause,
                        onSpeedChanged: _handleSpeedChanged,
                        onVoiceChanged: _handleVoiceChanged,
                      ),
                      const SizedBox(height: 30),

                      // Ayırıcı tatlı bir çizgi
                      Center(
                        child: Container(
                          width: 60, height: 4,
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Masal Metni (Senin o efsane cümle vurgulayıcı sistemin)
                      _HighlightedStoryText(
                        sentences: _sentences,
                        currentReadingIndex: _currentReadingIndex,
                      ),
                    ],
                  ),
                ),
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
      return const Text('');
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
          // Nunito fontu ile harika bir e-kitap deneyimi
          style: GoogleFonts.nunito(
            fontSize: 19,
            height: 1.8,
            color: isReading ? const Color(0xFF9A67EA) : const Color(0xFF4F5D75),
            fontWeight: isReading ? FontWeight.w800 : FontWeight.w600,
          ),
          child: Text(sentence + (index < sentences.length - 1 ? ' ' : '')),
        );
      }).toList(),
    );
  }
}

/// Sesli okuma kontrol paneli (Sınıf aynı kaldı, tasarıma uyması için renkleri güncellendi)
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
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
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
                  gradient: const LinearGradient(colors: [Color(0xFF9A67EA), Color(0xFF65C7F7)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF9A67EA).withOpacity(0.4), blurRadius: 16, spreadRadius: 2),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Ses hızı ayarı
          Row(
            children: [
              const Icon(Icons.speed_rounded, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text('Hız', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('${playbackSpeed.toStringAsFixed(1)}x', style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF2D3142), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: playbackSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15, 
            activeColor: const Color(0xFF65C7F7),
            inactiveColor: Colors.grey.shade300,
            onChanged: onSpeedChanged,
          ),
          const SizedBox(height: 20),
          // Ses tonu seçimi
          Row(
            children: [
              const Icon(Icons.record_voice_over_rounded, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text('Ses Tonu', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              const Spacer(),
              DropdownButton<String>(
                value: selectedVoice,
                dropdownColor: Colors.white,
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
                items: const [
                  DropdownMenuItem(value: 'Kadın', child: Text('Kadın', style: TextStyle(color: Color(0xFF2D3142)))),
                  DropdownMenuItem(value: 'Erkek', child: Text('Erkek', style: TextStyle(color: Color(0xFF2D3142)))),
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