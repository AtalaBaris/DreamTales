import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // YENİ: Hafıza kontrolü için eklendi

import 'core/theme/app_theme.dart';
import 'core/injection/injection.dart';
import 'core/config/app_config.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'package:dream_tales/features/onboarding/presentation/pages/onboarding_page.dart';

/// main - Uygulama giriş noktası
Future<void> main() async {
  // Flutter binding'leri initialize et
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle (eğer varsa)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('⚠️ .env dosyası yüklenemedi: $e');
    debugPrint('ℹ️ String.fromEnvironment veya default değerler kullanılacak');
  }

  // Config'i validate et 
  try {
    AppConfig.validate();
  } catch (e) {
    debugPrint('⚠️ Config validation hatası: $e');
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
  }

  // Dependency Injection setup
  await setupInjection();

  // YENİ: Uygulama ilk kez mi açılıyor kontrolü yapıyoruz!
  final prefs = await SharedPreferences.getInstance();
  // Eğer hafızada 'showHome' değeri yoksa (yani ilk girişse), onboarding'i göster (false döner).
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // Uygulamayı başlat (Riverpod ProviderScope ile sarmala)
  runApp(
    ProviderScope(
      child: DreamTalesApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class DreamTalesApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  
  const DreamTalesApp({
    super.key, 
    required this.hasSeenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Tales',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      // İŞTE BÜYÜ BURADA: Gördüyse Login'e, Görmediyse Karşılama Ekranına at!
      home: hasSeenOnboarding ? const LoginPage() : const OnboardingPage(),
    );
  }
}