import 'package:get/get.dart';
import '../../../di/injection.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';
import 'wordle_game_controller.dart';

class WordleGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordleGameController>(() => WordleGameController(
          getIt<GetWordsByGameIdUseCase>(),
        ));
  }
}
