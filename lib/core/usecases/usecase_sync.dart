import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// UseCaseSync - Senkron (async olmayan) use case'ler için base class
/// 
/// Async olmayan işlemler için kullanılır (örneğin: cache'den okuma).
abstract class UseCaseSync<Type, Params> {
  /// call - Use case'i senkron olarak çalıştırır
  Either<Failure, Type> call(Params params);
}
