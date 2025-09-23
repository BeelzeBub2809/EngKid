import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'game_api.g.dart';

@RestApi()
abstract class GameApi {
  factory GameApi(Dio dio, {String baseUrl}) = _GameApi;

  @GET('game/games/{gameId}')
  Future<ApiResponseObject> getGameDetail(
    @Path("gameId") int gameId,
  );
}
