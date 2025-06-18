import 'dart:async';
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

  AchieveStarController({
    required this.nextQuestion,
    required this.backQuestion,
    required this.relearn,
    required this.question,
    required this.quizUseCases,
    required this.setIsFullScreen,
    required this.readingId,
  });

  final TopicService _topicService = Get.find<TopicService>();

  late double totalStar = 0;

  @override
  void onInit() {
    super.onInit();
    LibFunction.effectFinish();
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   LibFunction.playAudioLocal(LocalAudio.finishLesson);
    // });
    getStars();
  }

  void getStars() {
    final reading =
    _topicService.topicReadings.topicReadings.readings.firstWhereOrNull(
          (element) => element.id == readingId,
    );
    if (reading == null) {
      return;
    }
    totalStar = reading.achievedStars;
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  void onSubmitPress() {
    nextQuestion();
  }
}
