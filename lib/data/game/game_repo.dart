import 'package:EngKid/data/core/remote/api/game_api/game_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/game/game_repository.dart';
import 'package:dio/dio.dart';

class GameRepositoryImp implements GameRepository {
  final GameApi gameApi;

  GameRepositoryImp({required this.gameApi});

  @override
  Future<Map<String, dynamic>?> getGameDetail(int gameId) async {
    try {
      final ApiResponseObject response = await gameApi.getGameDetail(gameId);
      final data = response.data;
      if (response.result && data != null) {
        return data as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[GameRepository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[GameRepository] Unknown exception: $e');
        print('[GameRepository] StackTrace: $stackTrace');
      }
      return null;
    }
  }
}
