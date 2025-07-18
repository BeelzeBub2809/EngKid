// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:EngKid/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/login/entities/login/login.dart';
import 'package:EngKid/domain/login/login_repository.dart';
import 'package:dio/dio.dart';

import '../../utils/lib_function.dart';

class LoginRepositoryImp implements LoginRepository {
  final AuthApi authApi;
  LoginRepositoryImp({required this.authApi});

  @override
  Future<Login> login(String username, String password) async {
    try{
      final ApiResponseObject response = await authApi.login(username, password);

      if (response.result) {
        return Login.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw response.message;
      }
    }on DioException catch (e) {
      final errorResponse = e.response?.data;

      // If your backend always returns JSON like { "message": "..."}
      final message = errorResponse is Map<String, dynamic>
          ? errorResponse["message"]
          : errorResponse?.toString();

      print("Error message: $message");
      throw message ?? 'An error occurred while logging in.';
    }

  }

  @override
  Future<dynamic> checkOtp(Map<String, dynamic> body) async {
    final ApiResponseObject response = await authApi.checkOtp(body);
    if (response.result) {
      return response.result;
    } else {
      throw response.message;
    }
  }

  @override
  Future<dynamic> signUp(Map<String, dynamic> body) async {
    try{
      final ApiResponseObject response = await authApi.signUp(body);
      print('responseSignUp : $response');
      return response.result;
    }on DioException catch (e) {
      final errorResponse = e.response?.data;

      // If your backend always returns JSON like { "message": "..."}
      final message = errorResponse is Map<String, dynamic>
          ? errorResponse["message"]
          : errorResponse?.toString();

      print("Error message: $message");
      throw message ?? 'An error occurred while logging in.';
    }

  }

  @override
  Future checkSignUp(Map<String, dynamic> body) async {
    final ApiResponseObject response = await authApi.checkSignUp(body);
    print('responseSignUp : $response');
    if (response.result) {
      return 0;
    } else {
      return response.code;
    }
  }
}
