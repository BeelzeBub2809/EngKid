import 'package:get/get.dart';
import 'package:EngKid/presentation/game/game_controller.dart';

class GameBinding extends Bindings {
  GameBinding();

  @override
  void dependencies() {
    Get.lazyPut(
      () => GameController(),
    );
  }
}
