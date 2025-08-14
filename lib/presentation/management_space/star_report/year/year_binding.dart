import 'package:get/instance_manager.dart';

import 'year_controller.dart';

class YearBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YearController>(
      () => YearController(starBoardUseCases: Get.find()),
    );
  }
}
