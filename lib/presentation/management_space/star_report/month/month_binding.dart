import 'package:get/instance_manager.dart';

import 'month_controller.dart';

class MonthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthController>(
      () => MonthController(starBoardUseCases: Get.find()),
    );
  }
}
