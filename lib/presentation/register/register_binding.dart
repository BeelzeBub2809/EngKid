import 'package:EngKid/presentation/register/register_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RegisterController(loginUsecases: Get.find()));
  }
}
