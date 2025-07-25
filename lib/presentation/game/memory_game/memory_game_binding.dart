import 'package:get/get.dart';
import 'memory_game_controller.dart';

class MemoryGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemoryGameController>(() => MemoryGameController());
  }
}
