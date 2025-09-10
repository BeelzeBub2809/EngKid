// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('auth/app-login')
  @FormUrlEncoded()
  Future<ApiResponseObject> login(
    @Field("username") String username,
    @Field("password") String password,
  );

  // tạo tài khoản
  @POST('auth/register')
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

  @POST('auth/forgot-password-mobile')
  @FormUrlEncoded()
  Future<void> sendOtp(
      @Body() Map<String, dynamic> body,
  );

  @POST('auth/reset-password-mobile')
  @FormUrlEncoded()
  Future<void> resetPassword(
      @Body() Map<String, dynamic> body,
  );
}
