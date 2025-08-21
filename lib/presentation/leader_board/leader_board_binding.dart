import 'package:get/get.dart';
import 'package:EngKid/presentation/leader_board/leader_board_controller.dart';
import 'package:EngKid/domain/reading/reading_usecases.dart';

class LeaderBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderBoardController>(
      () => LeaderBoardController(
        readingUsecases: Get.find<ReadingUsecases>(),
      ),
    );
  }
}
