import 'package:supabase_flutter/supabase_flutter.dart';

/// AuthRepository - Domain katmanında auth repository interface
/// 
/// Clean Architecture'da:
/// - Domain katmanı sadece abstract repository'yi bilir
/// - Data katmanı bu interface'i implement eder
/// - Supabase değişse bile domain katmanı değişmez
abstract class AuthRepository {
  /// Mevcut kullanıcı (giriş yapmış mı?)
  User? get currentUser;

  /// Oturum değişikliği dinleme (auth guard için)
  Stream<AuthState> get authStateChanges;

  /// Giriş yap
  /// 
  /// [email] - Kullanıcı email adresi
  /// [password] - Kullanıcı şifresi
  /// 
  /// Throws [AuthException] if login fails
  Future<void> signIn(String email, String password);

  /// Kayıt ol
  /// 
  /// [email] - Kullanıcı email adresi
  /// [password] - Kullanıcı şifresi
  /// 
  /// Throws [AuthException] if registration fails
  Future<void> signUp(String email, String password);

  /// Çıkış yap
  Future<void> signOut();
}
