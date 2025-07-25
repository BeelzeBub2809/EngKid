import 'package:get/get.dart';
import 'wordle_game_controller.dart';

class WordleGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordleGameController>(() => WordleGameController());
  }
}
