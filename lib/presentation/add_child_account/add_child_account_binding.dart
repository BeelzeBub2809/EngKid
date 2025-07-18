

import 'package:get/get.dart';
import 'package:EngKid/presentation/add_child_account/add_child_account_controller.dart';

class AddChildAccountBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AddChildAccountController(loginUsecases: Get.find()));
  }
}