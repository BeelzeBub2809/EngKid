import 'package:get/get.dart';

import 'e_library_controller.dart';

class ElibraryBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<GradeController>(
    //   () => GradeController(),
    // );
    Get.put(ElibraryController());
  }
}