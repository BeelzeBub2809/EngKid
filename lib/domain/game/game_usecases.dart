import 'package:EngKid/domain/game/game_repository.dart';

class GameUsecases {
  final GameRepository _gameRepository;

  GameUsecases(this._gameRepository);

  Future<Map<String, dynamic>?> getGameDetail(int gameId) async {
    return await _gameRepository.getGameDetail(gameId);
  }
}
