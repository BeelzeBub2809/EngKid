// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'feedback_api.g.dart';

@RestApi()
abstract class FeedbackApi {
  factory FeedbackApi(Dio dio, {String baseUrl}) = _FeedbackApi;

  @POST('/feedback/app/send-feedback')
  Future<ApiResponseObject> sendFeedback(
    @Body() Map<String, dynamic> body,
  );
}
