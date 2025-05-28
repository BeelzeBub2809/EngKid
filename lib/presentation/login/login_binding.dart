import 'package:get/get.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  LoginBinding();

  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(loginUsecases: Get.find()),
    );
  }
}
