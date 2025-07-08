// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'child_api.g.dart';
@RestApi()
abstract class ChildApi {
  factory ChildApi(Dio dio, {String baseUrl}) = _ChildApi;

  @GET('kid-student/parent-M/{kid_parent_id}')
  Future<ApiResponseObject> getAllKid(@Path("kid_parent_id") int kidParentId);
}
