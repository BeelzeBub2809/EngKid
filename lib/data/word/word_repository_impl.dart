import '../../domain/entities/word/word_entity.dart';
import '../../domain/repositories/word_repository.dart';
import 'word_api_client.dart';

class WordRepositoryImpl implements WordRepository {
  final WordApiClient _apiClient;

  WordRepositoryImpl(this._apiClient);

  @override
  Future<List<WordEntity>> getWordsByGameId(int gameId) async {
    try {
      final response = await _apiClient.getWordsByGameId(gameId);

      if (response.success) {
        return response.data.map((wordData) => wordData.toEntity()).toList();
      } else {
        throw Exception('Failed to fetch words: ${response.message}');
      }
    } catch (e) {
      throw Exception('Error fetching words by game ID $gameId: $e');
    }
  }
}
