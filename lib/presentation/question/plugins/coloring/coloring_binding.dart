import 'package:get/get.dart';
import 'coloring_controller.dart';

class ColoringBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ColoringController>(
      () => ColoringController(),
    );
  }
}
