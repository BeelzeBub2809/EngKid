import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/word/get_pronunciation_usecase.dart';
import 'package:EngKid/domain/word/get_words_by_game_id_usecase.dart';
import 'package:get/get.dart';
import 'image_puzzle_controller.dart';

class ImagePuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePuzzleGameController>(
      () => ImagePuzzleGameController(
          getIt.get<GetWordsByGameIdUseCase>(),
          getIt.get<GetPronunciationUrlUseCase>()
      ),
    );
  }
}
