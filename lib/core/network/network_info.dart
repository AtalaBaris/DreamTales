/// NetworkInfo - İnternet bağlantı durumunu kontrol eder
/// 
/// Clean Architecture'da data katmanı network durumunu kontrol etmek için
/// bu interface'i kullanır. Implementation platform-specific olabilir
/// (connectivity_plus paketi ile).
abstract class NetworkInfo {
  /// isConnected - İnternet bağlantısı var mı?
  Future<bool> get isConnected;
}

/// NetworkInfoImpl - NetworkInfo'nun implementasyonu
/// 
/// TODO: connectivity_plus paketi eklenince implement edilecek
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: connectivity_plus ile implement edilecek
    // Şimdilik her zaman true döner (development için)
    return true;
  }
}
