import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/word_response.dart';

part 'word_api_client.g.dart';

@RestApi()
abstract class WordApiClient {
  factory WordApiClient(Dio dio) = _WordApiClient;

  @GET('/word/mobile/game/{gameId}/words')
  Future<WordResponse> getWordsByGameId(
    @Path('gameId') int gameId,
  );
}
