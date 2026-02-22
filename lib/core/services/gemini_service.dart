import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // YENİ: Kasayı açmak için gereken paket

class GeminiService {
  // ESKİDEN BURADA OLAN GİZLİ ANAHTARI TAMAMEN SİLDİK!

  static Future<String> generateStory(String prompt) async {
    // YENİ: Anahtarı koddan değil, .env dosyasından çekiyoruz
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('API anahtarı bulunamadı! Lütfen .env dosyanızı kontrol edin.');
    }

    final model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
    );

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) {
        return 'Sihir gerçekleşemedi, Gemini boş bir yanıt döndü.';
      }
      
      return response.text!;
    } catch (e) {
      throw Exception('Gemini API Hatası: $e');
    }
  }
}