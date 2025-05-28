// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  // @GET('auth/user-info/{id}')
  // Future<ApiResponseObject> getUserInfo(
  //   @Path("id") int id,
  // );
}
