import 'package:get/get.dart';

import 'star_board_controller.dart';

class StarBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StarBoardController>(
      () => StarBoardController(),
    );
  }
}
