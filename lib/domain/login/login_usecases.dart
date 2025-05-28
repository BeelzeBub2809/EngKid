import 'package:EzLish/domain/login/entities/login/login.dart';
import 'package:EzLish/domain/login/login_repository.dart';

class LoginUsecases {
  final LoginRepository _loginRepository;
  LoginUsecases(this._loginRepository);

  Future<Login> login(String userLoginId) async =>
      _loginRepository.login(userLoginId);
  Future<dynamic> signUp(Map<String, dynamic> body) async =>
      _loginRepository.signUp(body);
  Future<dynamic> checkSignUp(Map<String, dynamic> body) async =>
      _loginRepository.checkSignUp(body);
  Future<dynamic> checkOtp(Map<String, dynamic> body) async =>
      _loginRepository.checkOtp(body);
}
