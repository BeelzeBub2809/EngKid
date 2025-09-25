import 'package:dio/dio.dart';

class GetPronunciationUrlUseCase {
  final Dio _dio;

  GetPronunciationUrlUseCase(this._dio);

  Future<String?> call(String word) async {
    try {
      final response = await _dio.get(
        "https://api.dictionaryapi.dev/api/v2/entries/en/$word",
      );

      final data = response.data;

      if (data is List && data.isNotEmpty) {
        for (final entry in data) {
          final phonetics = entry["phonetics"];
          if (phonetics != null && phonetics is List) {
            for (final phonetic in phonetics) {
              final audio = phonetic["audio"];
              if (audio != null && audio.toString().trim().isNotEmpty) {
                return audio.toString(); // ✅ return audio hợp lệ đầu tiên
              }
            }
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching pronunciation: $e");
    }
    return null; // nếu không tìm thấy audio
  }
}
