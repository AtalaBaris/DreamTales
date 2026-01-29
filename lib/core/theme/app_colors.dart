import 'package:flutter/material.dart';

/// Dream Tales uygulamasının renk paleti
class AppColors {
  AppColors._(); // Private constructor - sınıfın instance'ı oluşturulamaz

  // Ana renkler
  /// Sihirli Mor - Ana renk (Primary)
  static const Color primary = Color(0xFF6A1B9A);
  
  /// Masal Turuncusu - İkincil renk (Secondary)
  static const Color secondary = Color(0xFFFFB74D);

  // Arka plan renkleri
  /// Koyu lacivert arka plan (Dark Mode hissiyatı)
  static const Color background = Color(0xFF1A1F3A);
  
  /// Daha açık arka plan tonu
  static const Color backgroundLight = Color(0xFF252A4A);
  
  /// Surface rengi (Card, Container vb. için)
  static const Color surface = Color(0xFF2D3258);

  // Metin renkleri
  /// Ana metin rengi - Beyaz
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// İkincil metin rengi - Açık gri
  static const Color textSecondary = Color(0xFFB0B5C8);
  
  /// Üçüncül metin rengi - Orta gri
  static const Color textTertiary = Color(0xFF7E8499);

  // Aksent renkler
  /// Başarı rengi
  static const Color success = Color(0xFF4CAF50);
  
  /// Uyarı rengi
  static const Color warning = Color(0xFFFF9800);
  
  /// Hata rengi
  static const Color error = Color(0xFFE53935);
  
  /// Bilgi rengi
  static const Color info = Color(0xFF2196F3);

  // Gradient renkler (ileride kullanım için)
  /// Primary'den Secondary'ye gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
