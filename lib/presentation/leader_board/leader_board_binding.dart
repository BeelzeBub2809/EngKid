import 'package:get/get.dart';
import 'package:EngKid/presentation/leader_board/leader_board_controller.dart';

class LeaderBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderBoardController>(() => LeaderBoardController());
  }
}
