// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String baseUrl}) = _NotificationApi;

  @POST('/notify/app/get-by-parent')
  Future<ApiResponseObject> getNotificationsByParent(
    @Body() Map<String, dynamic> body,
  );
}
