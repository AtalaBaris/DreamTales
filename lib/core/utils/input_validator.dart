/// InputValidator - Form validation için yardımcı sınıf
/// 
/// Clean Architecture'da validation logic'i domain katmanında olmalı.
/// Bu sınıf shared validation kurallarını içerir.
class InputValidator {
  /// Email validation
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Password validation (minimum 6 karakter)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Empty string check
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
