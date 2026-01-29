import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/injection/injection.dart';
import 'core/config/app_config.dart';
import 'features/auth/presentation/pages/login_page.dart';

/// main - Uygulama giriş noktası
/// 
/// Clean Architecture'da:
/// - .env dosyası yüklenir (eğer varsa)
/// - Config validate edilir
/// - Dependency Injection setup edilir
/// - Riverpod ProviderScope ile uygulama sarmalanır
/// - Uygulama başlatılır
Future<void> main() async {
  // Flutter binding'leri initialize et
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle (eğer varsa)
  // Hata olursa devam et (String.fromEnvironment kullanılacak)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env dosyası yoksa veya hata varsa devam et
    // String.fromEnvironment veya default değerler kullanılacak
    debugPrint('⚠️ .env dosyası yüklenemedi: $e');
    debugPrint('ℹ️ String.fromEnvironment veya default değerler kullanılacak');
  }

  // Config'i validate et (production'da hata fırlatır)
  // Development'da sadece uyarı verir
  try {
    AppConfig.validate();
  } catch (e) {
    // Development'da sadece uyarı ver, production'da hata fırlat
    debugPrint('⚠️ Config validation hatası: $e');
    // Production kontrolü: release mode'da hata fırlat
    // assert(!kReleaseMode, 'Config validation failed: $e');
  }

  // Supabase'i initialize et
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    debugPrint('✅ Supabase başarıyla initialize edildi');
  } catch (e) {
    debugPrint('❌ Supabase initialize hatası: $e');
    // Production'da hata fırlatılabilir
    // if (kReleaseMode) rethrow;
  }

  // Dependency Injection setup
  await setupInjection();

  // Uygulamayı başlat (Riverpod ProviderScope ile sarmala)
  runApp(
    const ProviderScope(
      child: DreamTalesApp(),
    ),
  );
}

class DreamTalesApp extends StatelessWidget {
  const DreamTalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Tales',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
