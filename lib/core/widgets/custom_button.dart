import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// CustomButton - Reusable Button Component
/// 
/// React'taki gibi, bu widget bir "functional component" mantığında çalışır.
/// Props (parametreler) alır ve UI render eder.
/// 
/// Kullanım örneği (React benzeri):
/// ```dart
/// CustomButton(
///   text: "Giriş Yap",
///   onPressed: () => handleLogin(), // React'taki onClick handler'ına benzer
///   isLoading: false,
/// )
/// ```
class CustomButton extends StatelessWidget {
  /// text - Buton üzerinde görünecek metin
  /// React'taki children prop'una benzer
  final String text;

  /// onPressed - Butona tıklandığında çağrılan callback fonksiyon
  /// React'taki onClick handler'ına benzer
  /// null ise buton disabled olur (React'taki disabled prop'u gibi)
  final VoidCallback? onPressed;

  /// isLoading - Buton yükleniyor durumunda mı?
  /// React'taki loading state mantığına benzer
  /// true ise buton disabled olur ve loading spinner gösterilir
  final bool isLoading;

  /// backgroundColor - Butonun arka plan rengi
  /// React'taki style={{backgroundColor: '...'}} prop'una benzer
  final Color? backgroundColor;

  /// textColor - Buton metninin rengi
  /// React'taki style={{color: '...'}} prop'una benzer
  final Color? textColor;

  /// width - Butonun genişliği
  /// React'taki style={{width: '...'}} prop'una benzer
  final double? width;

  /// height - Butonun yüksekliği
  /// React'taki style={{height: '...'}} prop'una benzer
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // React'taki return JSX kısmına benzer
    // Burada widget tree'si oluşturulur

    return SizedBox(
      // Width - Butonun genişliği
      // React'taki style={{width: '100%'}} mantığına benzer
      width: width ?? double.infinity, // double.infinity = %100 genişlik

      // Height - Butonun yüksekliği
      // React'taki style={{height: '50px'}} mantığına benzer
      height: height ?? 56,

      child: ElevatedButton(
        // OnPressed - Butona tıklandığında çağrılan callback
        // React'taki onClick handler'ına benzer
        // isLoading true ise veya onPressed null ise buton disabled olur
        // React'taki disabled prop'u mantığına benzer
        onPressed: (isLoading || onPressed == null) ? null : onPressed,

        // Style - Butonun görsel stilini belirler
        // React'taki className veya style prop'una benzer
        style: ElevatedButton.styleFrom(
          // BackgroundColor - Butonun arka plan rengi
          // React'taki style={{backgroundColor: '...'}} prop'una benzer
          backgroundColor: backgroundColor ?? AppColors.primary,

          // ForegroundColor - Buton metninin rengi
          // React'taki style={{color: '...'}} prop'una benzer
          foregroundColor: textColor ?? AppColors.textPrimary,

          // Shape - Butonun şekli (yuvarlak köşeler)
          // React'taki borderRadius CSS özelliğine benzer
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),

          // Elevation - Butonun gölge derinliği
          // React'taki boxShadow CSS özelliğine benzer
          elevation: isLoading ? 0 : 8,

          // Padding - Butonun içerik padding'i
          // React'taki padding CSS özelliğine benzer
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),

          // DisabledBackgroundColor - Disabled durumdaki arka plan rengi
          // React'taki :disabled CSS pseudo-class'ına benzer
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
        ),

        // Child - Butonun içeriği
        // React'taki children prop'una benzer
        child: isLoading
            ? // Loading durumu - React'taki conditional rendering mantığına benzer
              // {isLoading ? <Spinner /> : <Text>Button</Text>} gibi
              const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textPrimary,
                    ),
                  ),
                )
            : // Normal durum - Buton metni gösterilir
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
