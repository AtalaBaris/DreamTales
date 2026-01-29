import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// CustomTextField - Reusable Text Input Component
/// 
/// React'taki gibi, bu widget bir "functional component" mantığında çalışır.
/// Props (parametreler) alır ve UI render eder.
/// 
/// Kullanım örneği (React benzeri):
/// ```dart
/// CustomTextField(
///   hintText: "Email",
///   controller: emailController, // React'taki useRef gibi
///   isPassword: false,
/// )
/// ```
class CustomTextField extends StatelessWidget {
  /// hintText - React'taki placeholder prop'una benzer
  /// Input alanında görünecek ipucu metni
  final String? hintText;

  /// controller - React'taki useRef veya controlled input mantığına benzer
  /// TextEditingController, input'un değerini kontrol eder ve okur
  final TextEditingController? controller;

  /// isPassword - Şifre alanı mı? (true ise karakterler gizlenir)
  /// React'taki type="password" prop'una benzer
  final bool isPassword;

  /// onChanged - Input değeri değiştiğinde çağrılan callback
  /// React'taki onChange handler'ına benzer
  final ValueChanged<String>? onChanged;

  /// keyboardType - Klavye tipi (email, number, text vb.)
  /// React'taki input type prop'una benzer
  final TextInputType? keyboardType;

  /// validator - Form validation için kullanılır
  /// React'taki form validation mantığına benzer
  final String? Function(String?)? validator;

  /// enabled - Input aktif/pasif durumu
  /// React'taki disabled prop'una benzer
  final bool enabled;

  /// maxLines - Maksimum satır sayısı (null ise tek satır)
  /// React'taki textarea rows prop'una benzer
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    // React'taki return JSX kısmına benzer
    // Burada widget tree'si oluşturulur
    
    return TextFormField(
      // Controller - React'taki controlled component mantığı
      // Input'un değerini kontrol eder ve okur
      controller: controller,

      // ObscureText - Şifre alanları için karakterleri gizler
      // React'taki type="password" mantığına benzer
      obscureText: isPassword,

      // KeyboardType - Klavye tipini belirler
      // React'taki input type prop'una benzer
      keyboardType: keyboardType ?? (isPassword ? null : TextInputType.emailAddress),

      // OnChanged - Değer değiştiğinde callback çağrılır
      // React'taki onChange={(e) => setValue(e.target.value)} mantığına benzer
      onChanged: onChanged,

      // Validator - Form validation için
      // React'taki form validation (örn: react-hook-form) mantığına benzer
      validator: validator,

      // Enabled - Input'un aktif/pasif durumu
      // React'taki disabled prop'una benzer
      enabled: enabled,

      // MaxLines - Maksimum satır sayısı
      // React'taki textarea rows prop'una benzer
      maxLines: maxLines ?? (isPassword ? 1 : null),

      // Style - Input'un görsel stilini belirler
      // React'taki className veya style prop'una benzer
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),

      // Decoration - Input'un görsel tasarımı (border, hint, label vb.)
      // React'taki CSS veya styled-components mantığına benzer
      decoration: InputDecoration(
        // HintText - Placeholder metni
        // React'taki placeholder prop'una benzer
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 16,
        ),

        // Filled - Arka planı doldur (true ise fillColor kullanılır)
        filled: true,
        fillColor: AppColors.backgroundLight,

        // ContentPadding - İçerik padding'i
        // React'taki padding CSS özelliğine benzer
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        // Border - Normal durumdaki border
        // React'taki border CSS özelliğine benzer
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none, // Border yok, sadece yuvarlak köşeler
        ),

        // EnabledBorder - Aktif ama focus olmamış durumdaki border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.textTertiary.withOpacity(0.3),
            width: 1,
          ),
        ),

        // FocusedBorder - Focus olduğunda (tıklandığında) görünen border
        // React'taki :focus CSS pseudo-class'ına benzer
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),

        // ErrorBorder - Validation hatası olduğunda görünen border
        // React'taki error state mantığına benzer
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),

        // FocusedErrorBorder - Hata var ve focus olduğunda
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),

        // PrefixIcon - Input'un sol tarafına ikon ekler
        // React'taki icon component'ine benzer
        prefixIcon: isPassword
            ? const Icon(
                Icons.lock_outline,
                color: AppColors.textSecondary,
              )
            : const Icon(
                Icons.email_outlined,
                color: AppColors.textSecondary,
              ),

        // SuffixIcon - Input'un sağ tarafına ikon ekler (şifre göster/gizle için kullanılabilir)
        // Şimdilik boş, ileride şifre göster/gizle butonu eklenebilir
        suffixIcon: null,
      ),
    );
  }
}
