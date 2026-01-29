import 'package:equatable/equatable.dart';

/// Failure - Clean Architecture'da hata yönetimi için base class
/// 
/// Tüm hata tipleri bu sınıftan türetilir.
/// dartz paketindeki Either<Failure, Success> ile kullanılır.
/// 
/// Her feature kendi failure'larını tanımlayabilir:
/// - ServerFailure: API hataları
/// - CacheFailure: Local storage hataları
/// - NetworkFailure: İnternet bağlantı hataları
/// - ValidationFailure: Form validation hataları
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// ServerFailure - API sunucu hataları
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// CacheFailure - Local storage hataları
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// NetworkFailure - İnternet bağlantı hataları
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// ValidationFailure - Form validation hataları
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// UnknownFailure - Beklenmeyen hatalar
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
