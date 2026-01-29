import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';

/// StoryRepository - Domain katmanında repository interface
/// 
/// Clean Architecture'da repository pattern:
/// - Domain katmanı sadece abstract repository'yi bilir
/// - Data katmanı bu interface'i implement eder
/// - API, Firebase, Supabase değişse bile domain katmanı değişmez
/// 
/// Bu sayede:
/// - Test edilebilirlik artar (mock repository kullanılabilir)
/// - Veri kaynağı değişikliği kolaylaşır
/// - Business logic veri kaynağından bağımsız olur
abstract class StoryRepository {
  /// createStory - Yeni masal oluşturur
  /// 
  /// Either<Failure, Story> döner:
  /// - Left(Failure): Hata durumu (örn: network hatası, validation hatası)
  /// - Right(Story): Başarılı sonuç
  Future<Either<Failure, Story>> createStory({
    required String title,
    required String content,
  });

  /// getStory - ID'ye göre masal getirir
  Future<Either<Failure, Story>> getStory(String id);

  /// getAllStories - Tüm masalları getirir
  Future<Either<Failure, List<Story>>> getAllStories();

  /// updateStory - Masalı günceller
  Future<Either<Failure, Story>> updateStory(Story story);

  /// deleteStory - Masalı siler
  Future<Either<Failure, void>> deleteStory(String id);
}
