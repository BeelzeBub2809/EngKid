import 'dart:async';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';

class AchieveStarController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final void Function() backQuestion;
  final void Function() relearn;
  final Function setIsFullScreen;
  final int readingId;
  final QuestionController questionController;

  AchieveStarController({
    required this.nextQuestion,
    required this.backQuestion,
    required this.relearn,
    required this.question,
    required this.quizUseCases,
    required this.setIsFullScreen,
    required this.readingId,
    required this.questionController
  });

  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();

  late double totalStar = 0;
  late int readingStar = 0;

  @override
  void onInit() async {
    super.onInit();
    LibFunction.effectFinish();
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   LibFunction.playAudioLocal(LocalAudio.finishLesson);
    // });
    int totalQuestions = questionController.totalQuestion;
    totalStar = totalQuestions > 5 ? questionController.stars/5 * 5 : questionController.stars/totalQuestions * 5;
    await _topicService.submitReadingResult(_userService.currentUser.id, questionController.readingId, questionController.stars, 1, questionController.doQuizDuration);
    getStars();
  }

  void getStars() {
    final reading =
    _topicService.topicReadings.topicReadings.readings.firstWhereOrNull(
          (element) => element.id == readingId,
    );
    print('Durration===============================: ${questionController.doQuizDuration}');
    print('Star==============================: ${questionController.stars}');
    print('Is Last Question================: ${questionController.isFinalQuestion()}');
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  void onSubmitPress() {
    nextQuestion();
  }
}
