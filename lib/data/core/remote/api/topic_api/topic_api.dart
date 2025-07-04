// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'topic_api.g.dart';
@RestApi()
abstract class TopicApi {
  factory TopicApi(Dio dio, {String baseUrl}) = _TopicApi;

  @POST('reading-category/all')
  Future<ApiResponseObject> getAll(@Body() Map<String, dynamic> body);
  @POST('reading-category/grade/{grade_id}')
  Future<ApiResponseObject> getByGrade(@Path("grade_id") int gradeId);
}
