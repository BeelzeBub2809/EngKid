// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('auth/login')
  @FormUrlEncoded()
  Future<ApiResponseObject> login(
    @Field("user_login_id") String userLoginId,
  );

  // tạo tài khoản
  @POST('auth/sign-up')
  @FormUrlEncoded()
  Future<ApiResponseObject> signUp(
    @Body() Map<String, dynamic> body,
  );
  // validate be
  @POST('auth/validate-account')
  @FormUrlEncoded()
  Future<ApiResponseObject> checkSignUp(
    @Body() Map<String, dynamic> body,
  );
  // check otp
  @POST('auth/check-otp')
  @FormUrlEncoded()
  Future<ApiResponseObject> checkOtp(
    @Body() Map<String, dynamic> body,
  );
}
