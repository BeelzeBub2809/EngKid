import 'package:get/get.dart';
import 'missing_word_controller.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';
import '../../../di/injection.dart';

class MissingWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissingWordController>(
      () => MissingWordController(getIt<GetWordsByGameIdUseCase>()),
    );
  }
}
