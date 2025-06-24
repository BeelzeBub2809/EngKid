import 'package:get/instance_manager.dart';
import 'package:EngKid/presentation/validate_parent/validate_parent_controller.dart';

class ValidateParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ValidateParentController>(
      () => ValidateParentController(),
    );
  }
}
