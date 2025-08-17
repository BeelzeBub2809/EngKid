import 'package:EngKid/presentation/forgot_pass/forgot_pass_controller.dart';
import 'package:get/get.dart';

class ForgotPassBinding extends Bindings {
  ForgotPassBinding();

  @override
  void dependencies() {
    Get.lazyPut(
      () => ForgotPassController(),
    );
  }
}
