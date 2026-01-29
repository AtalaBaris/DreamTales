import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

/// CreateStoryParams - CreateStory use case'inin parametreleri
/// 
/// Clean Architecture'da use case parametreleri ayrı bir class'ta tutulur.
/// Bu sayede parametreler type-safe ve test edilebilir olur.
class CreateStoryParams {
  final String title;
  final String content;

  const CreateStoryParams({
    required this.title,
    required this.content,
  });
}

/// CreateStory - Masal oluşturma use case'i
/// 
/// Clean Architecture'da use case'ler:
/// - Tek bir sorumluluğa sahiptir (Single Responsibility Principle)
/// - Business logic'i içerir
/// - Repository'ye bağımlıdır ama veri kaynağından bağımsızdır
/// 
/// Kullanım örneği:
/// ```dart
/// final useCase = CreateStory(repository);
/// final result = await useCase(CreateStoryParams(
///   title: 'Masal Başlığı',
///   content: 'Masal içeriği...',
/// ));
/// 
/// result.fold(
///   (failure) => print('Hata: ${failure.message}'),
///   (story) => print('Başarılı: ${story.title}'),
/// );
/// ```
class CreateStory implements UseCase<Story, CreateStoryParams> {
  final StoryRepository repository;

  CreateStory(this.repository);

  @override
  Future<Either<Failure, Story>> call(CreateStoryParams params) async {
    // Business logic: Validation
    if (params.title.trim().isEmpty) {
      return const Left(ValidationFailure('Başlık boş olamaz'));
    }

    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('İçerik boş olamaz'));
    }

    // Repository'ye delegate et
    return await repository.createStory(
      title: params.title.trim(),
      content: params.content.trim(),
    );
  }
}
