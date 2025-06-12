import 'package:get/get.dart';

import 'management_space_controller.dart';

class ManagementSpaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagementSpaceController>(
      () => ManagementSpaceController(),
    );
  }
}
