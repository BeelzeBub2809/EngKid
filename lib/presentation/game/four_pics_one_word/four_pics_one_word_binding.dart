import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/word/get_words_by_game_id_usecase.dart';
import 'package:get/get.dart';
import 'four_pics_one_word_controller.dart';

class FourPicsOneWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FourPicsOneWordController>(() =>
        FourPicsOneWordController(getIt.get<GetWordsByGameIdUseCase>()
    ));
  }
}
