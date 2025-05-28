// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:EzLish/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EzLish/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EzLish/domain/login/entities/login/login.dart';
import 'package:EzLish/domain/login/login_repository.dart';

import '../../utils/lib_function.dart';

class LoginRepositoryImp implements LoginRepository {
  final AuthApi authApi;
  LoginRepositoryImp({required this.authApi});

  @override
  Future<Login> login(String userLoginId) async {
    final ApiResponseObject response = await authApi.login(userLoginId);
    if (response.result) {
      return Login.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw response.message;
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
    final ApiResponseObject response = await authApi.signUp(body);
    print('responseSignUp : $response');
    if (response.result) {
      return response.data;
    } else {
      return response.message;
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
