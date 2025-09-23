import '../entities/word/word_entity.dart';
import '../repositories/word_repository.dart';

class GetWordsByGameIdUseCase {
  final WordRepository _repository;

  GetWordsByGameIdUseCase(this._repository);

  Future<List<WordEntity>> call(int gameId) async {
    try {
      return await _repository.getWordsByGameId(gameId);
    } catch (e) {
      throw Exception('Failed to get words for game $gameId: $e');
    }
  }
}
