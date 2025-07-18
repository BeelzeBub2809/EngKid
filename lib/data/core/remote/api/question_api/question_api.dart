import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
part 'question_api.g.dart';
@RestApi()
abstract class QuestionApi {
  factory QuestionApi(Dio dio, {String baseUrl}) = _QuestionApi;

  @POST('questions/get-by-readingId')
  Future<ApiResponseObject> getQuestionByReadingId(@Body() Map<String, dynamic> body);
}