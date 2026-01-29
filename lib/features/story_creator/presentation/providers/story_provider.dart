import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/create_story.dart';
import '../../domain/usecases/get_all_stories.dart';

/// StoryState - Story state yönetimi için state class
/// 
/// Riverpod ile state management:
/// - Immutable state
/// - Type-safe
/// - Test edilebilir
/// 
/// freezed ile daha gelişmiş yapılabilir, şimdilik basit class kullanıyoruz
class StoryState {
  final bool isLoading;
  final List<Story> stories;
  final Failure? error;

  const StoryState({
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });

  /// copyWith - Immutable update için
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

/// storyNotifierProvider - Story state yönetimi için Riverpod provider
/// 
/// Riverpod ile:
/// - State otomatik olarak yönetilir
/// - Widget'lar state değişikliklerine otomatik subscribe olur
/// - Test edilebilir (mock provider kullanılabilir)
final storyNotifierProvider =
    StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier();
});

/// StoryNotifier - Story state yönetimi için notifier
/// 
/// Clean Architecture'da presentation katmanı:
/// - Use case'leri çağırır
/// - State'i yönetir
/// - UI'ı günceller
class StoryNotifier extends StateNotifier<StoryState> {
  final CreateStory _createStory;
  final GetAllStories _getAllStories;

  StoryNotifier()
      : _createStory = getIt<CreateStory>(),
        _getAllStories = getIt<GetAllStories>(),
        super(const StoryState());

  /// loadStories - Tüm masalları yükle
  Future<void> loadStories() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getAllStories(const NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure,
        );
      },
      (stories) {
        state = state.copyWith(
          isLoading: false,
          stories: stories,
        );
      },
    );
  }

  /// createStory - Yeni masal oluştur
  Future<void> createStory({
    required String title,
    required String content,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _createStory(
      CreateStoryParams(title: title, content: content),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure,
        );
      },
      (story) {
        // Başarılı: Yeni story'yi listeye ekle ve tüm listeyi yeniden yükle
        state = state.copyWith(isLoading: false);
        loadStories(); // Listeyi güncelle
      },
    );
  }
}
