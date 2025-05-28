import 'package:EzLish/domain/login/entities/login/login.dart';

abstract class LoginRepository {
  Future<Login> login(String userLoginId);

  Future<dynamic> signUp(Map<String, dynamic> body);
  Future<dynamic> checkSignUp(Map<String, dynamic> body);

  Future<dynamic> checkOtp(Map<String, dynamic> body);
}
