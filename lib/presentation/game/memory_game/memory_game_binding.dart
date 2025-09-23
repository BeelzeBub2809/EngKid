import 'package:get/get.dart';
import '../../../di/injection.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';
import 'memory_game_controller.dart';

class MemoryGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemoryGameController>(() => MemoryGameController(
          getIt.get<GetWordsByGameIdUseCase>(),
        ));
  }
}
