// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/setting/setting.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

const theSource = AudioSource.microphone;

class FillTableController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final Function setIsFullScreen;
  final int readingId;
  final QuestionController questionController;

  FillTableController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.setIsFullScreen,
    required this.readingId,
    required this.questionController
  });

  final UserService _userService = Get.find<UserService>();
  final recorder = FlutterSoundRecorder();

  final RxString _text = ''.obs;
  List<String> _user_answers = List<String>.empty(growable: true);
  final RxBool _isFilledText = false.obs;
  late Codec codec = Codec.aacMP4;
  late String mPath = '';
  late String pathAudio = "";
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  final RxBool _mPlayerIsInited = false.obs;
  final RxBool _mRecorderIsInited = false.obs;
  final RxBool _mplaybackReady = false.obs;
  final RxBool _hasPermissionMicrophone = false.obs;
  final RxBool _isCompleted = false.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isFullScreen = false.obs;
  final RxBool _isHasImage = false.obs;

  String get text => _text.value;
  bool get isFilledText => _isFilledText.value;
  bool get hasPermissionMicrophone => _hasPermissionMicrophone.value;
  bool get isCompleted => _isCompleted.value;
  bool get mPlayerIsInited => _mPlayerIsInited.value;
  bool get mRecorderIsInited => _mRecorderIsInited.value;
  bool get mplaybackReady => _mplaybackReady.value;
  bool get isRecording => _isRecording.value;
  bool get isPlaying => _isPlaying.value;
  bool get isFullScreen => _isFullScreen.value;
  bool get isHasImage => _isHasImage.value;
  FlutterSoundPlayer get mPlayer => _mPlayer!;
  FlutterSoundRecorder get mRecorder => _mRecorder!;

  set isFullScreen(bool value) {
    _isFullScreen.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    LibFunction.stopBackgroundSound();

    questionController.readQuestion(question,null);

    for (var element in question.childQuestion) {
      _user_answers.add("");

      if(element.image1 != ''
      ){
        _isHasImage.value = true;
      }
    }
  }

  void onChangeInput({required int rowIndex, required int columnIndex, required String input}) {
    print("Answer for row $rowIndex, column $columnIndex: $input");
    _text.value = input;
    // _user_answers[] = input;
    _isCompleted.value = true;
    if (input != "") {
      _isFilledText.value = true;
    } else {
      _isFilledText.value = false;
    }
    setIsFullScreen(false);
    _isFullScreen.value = false;
    LibFunction.effectExit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onSubmitPress() async {
    if (Get.isDialogOpen!) return;

    if (_text.value == "") {
      LibFunction.effectWrongAnswer();
      Get.dialog(
        DialogNotiQuestion(
          type: TypeDialog.warning,
          onNext: () {},
          onReTry: () {},
          onClose: () {},
        ),
        barrierDismissible: false,
        barrierColor: null,
      );
      return;
    }

    final isFinalQuestion = questionController.isFinalQuestion();

    var index = 0;
    for (var element in question.childQuestion) {
      quizUseCases.submitQuestion(
        readingId: readingId,
        questionId: element.questionId,
        isCorrect: true,
        attempt: question.attempt,
        duration: questionController.getTimeDoingQuizFromStorage(),
        isCompleted: isFinalQuestion,
        data: {
          "isFile": !_isFilledText.value && pathAudio != "",
          "question_answer[${element.questionId}]":
          !_isFilledText.value && pathAudio != ""
              ? pathAudio.split(Platform.pathSeparator).last
              : _user_answers[index],
        },
      );

      index++;
    }

    questionController.updateCheckCorrectAnswer(questionController.questionIndex, true);
    nextQuestion();
  }
}
