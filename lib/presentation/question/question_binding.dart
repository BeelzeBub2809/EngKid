import 'package:get/instance_manager.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';

import 'question_controller.dart';

class QuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionController>(
      () => QuestionController(quizUseCases: Get.find<QuizUseCases>()),
    );
  }
}
