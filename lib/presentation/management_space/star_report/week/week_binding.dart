import 'package:get/instance_manager.dart';

import 'week_controller.dart';

class WeekBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeekController>(
      () => WeekController(starBoardUseCases: Get.find()),
    );
  }
}
