import 'package:get/instance_manager.dart';
import 'package:EngKid/presentation/declare_parent_code/declare_parent_code_controller.dart';

class DeclareParentCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeclareParentCodeController>(
      () => DeclareParentCodeController(),
    );
  }
}
