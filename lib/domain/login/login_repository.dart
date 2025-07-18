import 'package:EngKid/domain/login/entities/login/login.dart';

abstract class LoginRepository {
  Future<Login> login(String username, String password);

  Future<dynamic> signUp(Map<String, dynamic> body);
  Future<dynamic> checkSignUp(Map<String, dynamic> body);

  Future<dynamic> checkOtp(Map<String, dynamic> body);
}
