import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // Using LibreTranslate API as a free alternative to Google Translate
  static const String _baseUrl = 'https://libretranslate.com/translate';
  static const String _myMemoryUrl = 'https://api.mymemory.translated.net/get';
  static const String _lingvaUrl = 'https://lingva.ml/api/v1';

  // Alternative free translation APIs you can use:
  // 1. MyMemory: https://api.mymemory.translated.net/get
  // 2. Lingva: https://lingva.ml/api/v1/

  static Future<String> translateToVietnamese(String englishText) async {
    if (englishText.trim().isEmpty) {
      return englishText;
    }

    try {
      // Try LibreTranslate first
      final result = await _translateWithLibreTranslate(englishText);
      if (result.isNotEmpty) {
        return result;
      }

      // Fallback to MyMemory API
      return await _translateWithMyMemory(englishText);
    } catch (e) {
      print('Translation error: $e');
      // Return original text if translation fails
      return englishText;
    }
  }

  static Future<String> _translateWithLibreTranslate(String text) async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(
                {'q': text, 'source': 'en', 'target': 'vi', 'format': 'text'}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translatedText'] ?? text;
      }
      return '';
    } catch (e) {
      print('LibreTranslate error: $e');
      return '';
    }
  }

  static Future<String> _translateWithMyMemory(String text) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url = '$_myMemoryUrl?q=$encodedText&langpair=en|vi';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['responseStatus'] == 200) {
          return data['responseData']['translatedText'] ?? text;
        }
      }
      return text;
    } catch (e) {
      print('MyMemory translation error: $e');
      return text;
    }
  }

  // For testing purposes - you can add more translation providers here
  static Future<String> _translateWithLingva(String text) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://lingva.ml/api/v1/en/vi/${Uri.encodeComponent(text)}'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translation'] ?? text;
      }
      return text;
    } catch (e) {
      print('Lingva translation error: $e');
      return text;
    }
  }
}
