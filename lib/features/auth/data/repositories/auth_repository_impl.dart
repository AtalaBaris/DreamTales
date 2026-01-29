import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

/// AuthRepositoryImpl - AuthRepository'nin Supabase implementasyonu
/// 
/// Clean Architecture'da:
/// - Domain repository interface'ini implement eder
/// - Supabase client'ı kullanır
/// - Hataları yakalar ve uygun şekilde fırlatır
class AuthRepositoryImpl implements AuthRepository {
  final GoTrueClient _auth;

  AuthRepositoryImpl() : _auth = Supabase.instance.client.auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (e) {
      // Supabase auth hatalarını yeniden fırlat
      throw AuthException(
        e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      // Beklenmeyen hatalar
      throw Exception('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.signUp(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (e) {
      // Supabase auth hatalarını yeniden fırlat
      throw AuthException(
        e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      // Beklenmeyen hatalar
      throw Exception('Kayıt olurken bir hata oluştu: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(
        e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw Exception('Çıkış yapılırken bir hata oluştu: $e');
    }
  }
}
