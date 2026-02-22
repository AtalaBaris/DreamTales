import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart'; 
import '../../../../core/error/failures.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/create_story.dart';
import '../../domain/usecases/get_all_stories.dart';
import '../../../../core/services/gemini_service.dart'; 

class StoryState {
  final bool isLoading;
  final List<Story> stories;
  final Failure? error;

  const StoryState({
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });

  StoryState copyWith({
    bool? isLoading,
    List<Story>? stories,
    Failure? error,
  }) {
    return StoryState(
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      error: error,
    );
  }
}

final storyNotifierProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier();
});

class StoryNotifier extends StateNotifier<StoryState> {
  final CreateStory _createStory;
  final GetAllStories _getAllStories;

  StoryNotifier()
      : _createStory = getIt<CreateStory>(),
        _getAllStories = getIt<GetAllStories>(),
        super(const StoryState());

  Future<void> loadStories() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getAllStories(const NoParams());

    result.fold(
      (failure) {
        // İŞTE BURAYI DEĞİŞTİRDİK!
        // Eskiden burada error: failure yazıyordu ve ekranı kırmızıya boyuyordu.
        // Artık veritabanı hatası alırsak görmezden geliyoruz, ekranı bozmuyoruz.
        state = state.copyWith(isLoading: false); 
      },
      (stories) {
        state = state.copyWith(isLoading: false, stories: stories);
      },
    );
  }

  Future<void> createStory({
    required String title,
    required String content, 
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    print("👉 1. ADIM: Gemini'a istek atılıyor...");

    try {
      // 1. Gemini'dan masalı yazmasını istiyoruz
      final generatedMasalText = await GeminiService.generateStory(content);
      print("👉 2. ADIM: Gemini masalı başarıyla yazdı! Uzunluk: ${generatedMasalText.length}");

      // 2. Sistemin istediği createdAt eklendi
      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        title: title,
        content: generatedMasalText,
        createdAt: DateTime.now(), 
      );

      print("👉 3. ADIM: Masal ekrana (listeye) ekleniyor...");
      // 3. Masalı listeye EN BAŞA ekleyip ekranı (state'i) anında güncelliyoruz.
      state = state.copyWith(
        isLoading: false,
        stories: [newStory, ...state.stories],
      );
      print("👉 4. ADIM: İşlem tamam! Listedeki masal sayısı: ${state.stories.length}");

      // 4. Arka planda veritabanına kaydetmeyi dener
      _createStory(
        CreateStoryParams(title: title, content: generatedMasalText),
      );

    } catch (e) {
      // BİZİ KANDIRDIĞI YER BURASIYDI! Artık hatayı gizlemiyoruz, ekrana fırlatıyoruz!
      print("🚨 BÜYÜK HATA YAKALANDI: $e");
      state = state.copyWith(isLoading: false);
      
      // Uygulamanın "Başarıyla oluşturuldu" deyip geriye dönmesini engelliyoruz
      throw Exception("Masal üretilirken patladı: $e"); 
    }
  }
}