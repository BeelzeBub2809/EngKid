import 'package:get/instance_manager.dart';

import 'personal_info_controller.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoController>(
      () => PersonalInfoController(),
    );
  }
}
