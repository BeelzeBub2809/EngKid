import 'package:get/get.dart';
import 'image_puzzle_controller.dart';

class ImagePuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePuzzleGameController>(
      () => ImagePuzzleGameController(),
    );
  }
}
