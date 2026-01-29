import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// UseCase - Clean Architecture'da business logic için base class
/// 
/// Her use case tek bir sorumluluğa sahiptir (Single Responsibility Principle).
/// 
/// Generic parametreler:
/// - Type: Use case'in döndüreceği veri tipi
/// - Params: Use case'in alacağı parametreler (opsiyonel)
/// 
/// Kullanım örneği:
/// ```dart
/// class CreateStoryUseCase implements UseCase<Story, CreateStoryParams> {
///   final StoryRepository repository;
///   
///   CreateStoryUseCase(this.repository);
///   
///   @override
///   Future<Either<Failure, Story>> call(CreateStoryParams params) async {
///     return await repository.createStory(params.title, params.content);
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  /// call - Use case'i çalıştırır
  /// 
  /// Either<Failure, Type> döner:
  /// - Left(Failure): Hata durumu
  /// - Right(Type): Başarılı sonuç
  Future<Either<Failure, Type>> call(Params params);
}

/// NoParams - Parametre gerektirmeyen use case'ler için
class NoParams {
  const NoParams();
}
