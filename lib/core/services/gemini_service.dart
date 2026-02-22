import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  
  static const String _apiKey = 'AIzaSyD67-bm1M49AOR4KW0KkY3RLMx7KyA4PPI'; 

  static Future<String> generateStory(String prompt) async {
    if (_apiKey.isEmpty) {
      throw Exception('API anahtarı bulunamadı!');
    }

  
    final model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: _apiKey,
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