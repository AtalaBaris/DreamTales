import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AppConfig - Uygulama konfigürasyonu
/// 
/// Güvenli config yönetimi:
/// 1. Önce .env dosyasından okur (development için)
/// 2. Yoksa String.fromEnvironment kullanır (CI/CD için)
/// 3. Hiçbiri yoksa default değerler (sadece development için)
/// 
/// Kullanım:
/// - Development: .env dosyası oluştur ve değerleri ekle
/// - CI/CD: --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
/// - Production: Environment variables veya .env dosyası
class AppConfig {
  AppConfig._(); // Private constructor - instance oluşturulamaz

  /// Supabase URL
  /// 
  /// Öncelik sırası:
  /// 1. .env dosyasından SUPABASE_URL
  /// 2. String.fromEnvironment (--dart-define ile)
  /// 3. Default değer (sadece development için)
  static String get supabaseUrl {
    // .env dosyasından oku (eğer yüklendiyse)
    final envUrl = dotenv.env['SUPABASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    // String.fromEnvironment'dan oku (--dart-define ile)
    const envDefinedUrl = String.fromEnvironment('SUPABASE_URL');
    if (envDefinedUrl.isNotEmpty) {
      return envDefinedUrl;
    }

    // Default değer (sadece development için)
    // ⚠️ UYARI: Production'da buraya gerçek değer yazmayın!
    // Production için mutlaka .env veya --dart-define kullanın
    return 'https://BURAYA_PROJECT_URL_YAZ.supabase.co';
  }

  /// Supabase Anonymous Key
  /// 
  /// Öncelik sırası:
  /// 1. .env dosyasından SUPABASE_ANON_KEY
  /// 2. String.fromEnvironment (--dart-define ile)
  /// 3. Default değer (sadece development için)
  static String get supabaseAnonKey {
    // .env dosyasından oku (eğer yüklendiyse)
    final envKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }

    // String.fromEnvironment'dan oku (--dart-define ile)
    const envDefinedKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (envDefinedKey.isNotEmpty) {
      return envDefinedKey;
    }

    // Default değer (sadece development için)
    // ⚠️ UYARI: Production'da buraya gerçek değer yazmayın!
    // Production için mutlaka .env veya --dart-define kullanın
    return 'BURAYA_ANON_KEY_YAZ';
  }

  /// Config'in yüklü olup olmadığını kontrol et
  /// 
  /// Production'da gerçek değerlerin yüklendiğinden emin olmak için kullanılır
  static bool get isConfigured {
    return supabaseUrl != 'https://BURAYA_PROJECT_URL_YAZ.supabase.co' &&
        supabaseAnonKey != 'BURAYA_ANON_KEY_YAZ';
  }

  /// Config değerlerini validate et
  /// 
  /// Uygulama başlangıcında çağrılmalıdır
  static void validate() {
    if (!isConfigured) {
      throw Exception(
        'Supabase config değerleri ayarlanmamış!\n'
        'Lütfen .env dosyası oluşturun veya --dart-define ile değerleri verin.\n'
        'Detaylar için README.md dosyasına bakın.',
      );
    }

    // URL format kontrolü
    if (!supabaseUrl.startsWith('https://') ||
        !supabaseUrl.contains('.supabase.co')) {
      throw Exception(
        'Geçersiz Supabase URL formatı: $supabaseUrl\n'
        'URL şu formatta olmalı: https://PROJECT_ID.supabase.co',
      );
    }

    // Key uzunluk kontrolü (anon key genellikle uzun bir string)
    if (supabaseAnonKey.length < 50) {
      throw Exception(
        'Geçersiz Supabase Anon Key formatı.\n'
        'Key çok kısa görünüyor. Lütfen kontrol edin.',
      );
    }
  }
}
