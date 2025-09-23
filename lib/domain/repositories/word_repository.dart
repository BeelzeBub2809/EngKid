import '../entities/word/word_entity.dart';

abstract class WordRepository {
  /// Fetch words for a specific game
  /// [gameId] - The ID of the game to fetch words for
  /// Returns list of [WordEntity] objects
  /// Throws [Exception] if request fails
  Future<List<WordEntity>> getWordsByGameId(int gameId);
}
