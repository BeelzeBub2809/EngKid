import 'package:get/get.dart';
import 'puzzle_game_controller.dart';

class PuzzleGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PuzzleGameController>(() => PuzzleGameController());
  }
}
