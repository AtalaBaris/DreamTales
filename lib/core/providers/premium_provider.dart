import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Artık basit bir StateProvider değil, hafızayı yöneten bir StateNotifier kullanıyoruz.
final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _loadPremiumState(); // Uygulama açılır açılmaz hafızaya bak!
  }

  // Hafızadan 'isPro' değerini okur
  Future<void> _loadPremiumState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isPro') ?? false;
  }

  // PRO durumunu hem ekranda değiştirir hem de kalıcı olarak hafızaya yazar
  Future<void> setPremium(bool isPro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPro', isPro);
    state = isPro;
  }
}