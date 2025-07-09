import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audio_control.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/background_audio_control.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import '../../widgets/dialog/dialog_noti_question.dart';
import 'data_game.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class QuestionController extends GetxController with WidgetsBindingObserver {
  final QuizUseCases quizUseCases;
  QuestionController({required this.quizUseCases});

  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  final BackgroundAudioControl _backgroundAudioControl = BackgroundAudioControl();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();

  List<String> pluginRouteNames = List<String>.empty(growable: true);

  final RxBool _isFullScreen = false.obs;
  final RxBool _readingQuestionState = false.obs;
  final RxInt _questionIndex = 0.obs;
  final List<Question> _unCompleteQuestions = [];
  List<bool> checkCorrectAnswer = List<bool>.empty(growable: true);

  late int readingId = -1;
  late bool isBack = false;
  late Timer _timerReading;
  late double _duration = 0;
  late String coloringUrl = LocalImage.coloring01;
  bool get isFullScreen => _isFullScreen.value;
  // bool get isBack => isBack;
  List<Question> get questionList => _unCompleteQuestions;
  final AudioControl _audioControl = AudioControl.instance;
  final player = AudioPlayer();
  int get questionIndex => _questionIndex.value;
  late double _doQuizDuration = 0;
  late int videoDuration = 0;
  double get doQuizDuration => _doQuizDuration;

  set isFullScreen(bool value) {
    _isFullScreen.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initQuestion();
  }

  Future<void> onNextBtnPress() async {
    final Question currentQuestion = _unCompleteQuestions[_questionIndex.value];

    // if(isFinalQuestion()){
    //   final isCorrectAll = isCorrectAllQuestion();
    //
    //   if (isCorrectAll) {
    //     LibFunction.effectTrueAnswer();
    //   } else {
    //     LibFunction.effectWrongAnswer();
    //   }
    //   Get.dialog(
    //     DialogNotiQuestion(
    //       type: isCorrectAll ? TypeDialog.success : TypeDialog.failed,
    //       onNext: () {
    //         _nextQuestion(currentQuestion);
    //       },
    //       onReTry: () {
    //         relearnQuestion();
    //       },
    //       onClose: () {},
    //     ),
    //     barrierDismissible: false,
    //     barrierColor: null,
    //   );
    //
    // }else{
    //   _nextQuestion(currentQuestion);
    // }
    await Future.delayed(const Duration(milliseconds: 200));
    _nextQuestion(currentQuestion);
  }

  void onStopBtnPress() async {
    await AudioControl.instance.stopAudio();
    await LibFunction.effectConfirmPop();
    LibFunction.playBackgroundSound(LocalAudio.soundInApp);
    Get.back();
  }

  void _initQuestion() {
    final Quiz quiz = Get.arguments[0] as Quiz;

    quizUseCases.reading = Get.arguments[2] as Reading;

    readingId = quiz.reading.id;
    _topicService.readingName = quiz.reading.name;

    _unCompleteQuestions.add(Question(
        video: quiz.reading.video,
        typeCode: 'V',
        video_mong: quiz.reading.videoMong));
    late String contentReadGame = "";
    try {
      final int dataGameIndex = (Get.arguments[2] as Reading).positionId % 100;
      if (dataGameIndex == 0) {
        contentReadGame =
        dataGame[_topicService.currentGrade.id - 1][99].values.toList()[2];
      } else {
        contentReadGame = dataGame[_topicService.currentGrade.id - 1]
        [dataGameIndex - 1]
            .values
            .toList()[2];
      }
      handleGetColoringUrl(dataGameIndex);

      coloringUrl = getRandomColoringImage();
    } catch (e) {
//
    }
    _unCompleteQuestions
        .add(const Question(typeCode: 'read', question: "This is reading content"));
    _unCompleteQuestions.addAll(quiz.questions.sublist(0));

    _unCompleteQuestions.add(const Question(typeCode: 'achieve_star'));
    _unCompleteQuestions.add(const Question(typeCode: 'drawing'));
    _unCompleteQuestions.add(const Question(typeCode: 'coloring'));
    _unCompleteQuestions.add(const Question(typeCode: 'final_screen'));

    if (_unCompleteQuestions.isNotEmpty) {
      LibFunction.stopBackgroundSound();
      _checkVideoPlugin(_unCompleteQuestions[0]);
      _getPlugin(_unCompleteQuestions);
      _initCheckCorrectAnswer();
    } else {
      Get.back();
    }
    final double duration = getTimeDurationFromStorage();
    final double doQuizDuration = getTimeDoingQuizFromStorage();
    countTimeReading(duration);
    countTimeDoingQuiz(doQuizDuration);
  }

  void _initCheckCorrectAnswer() {
    checkCorrectAnswer = List<bool>.filled(_unCompleteQuestions.length, false);
    if (checkCorrectAnswer.isNotEmpty) {
      checkCorrectAnswer[0] = true;
      checkCorrectAnswer[1] = true;
      if (checkCorrectAnswer.length > 1) {
        checkCorrectAnswer[checkCorrectAnswer.length - 1] = true;
        checkCorrectAnswer[checkCorrectAnswer.length - 2] = true;
        checkCorrectAnswer[checkCorrectAnswer.length - 3] = true;
        checkCorrectAnswer[checkCorrectAnswer.length - 4] = true;
      }
    }
  }

  void updateCheckCorrectAnswer(int index, bool isCorrect) {
    checkCorrectAnswer[index] = isCorrect;
  }

  bool isCorrectAllQuestion() {
    print(checkCorrectAnswer);
    if (checkCorrectAnswer.contains(false)) {
      return false;
    }
    return true;
  }

  Future<void> _nextQuestion(Question currentQuestion) async {
    if (AudioControl.instance.isPlaying) {
      await AudioControl.instance.stopAudio();
    }
    await LibFunction.effectConfirmPop();
    if (_questionIndex.value < pluginRouteNames.length - 1) {
      _navigateToNextQuestion();
    } else {
      handleMyProgress();
      submitCompletedQuestion();
      Get.back();
    }
  }

  String getRandomColoringImage(){
    final List<String> listColoringImage = [
      LocalImage.coloring01,
      LocalImage.coloring02,
      LocalImage.coloring03,
      LocalImage.coloring04,
      LocalImage.coloring05,
      LocalImage.coloring06,
      LocalImage.coloring07,
      LocalImage.coloring08,
      LocalImage.coloring09,
      LocalImage.coloring10,
      LocalImage.coloring11,
      LocalImage.coloring12,
      LocalImage.coloring13,
      LocalImage.coloring14,
      LocalImage.coloring15,
      LocalImage.coloring16,
      LocalImage.coloring17,
      LocalImage.coloring18,
      LocalImage.coloring19,
      LocalImage.coloring20,
      LocalImage.coloring21,
      LocalImage.coloring22,
      LocalImage.coloring23,
      LocalImage.coloring24,
      LocalImage.coloring25,
      LocalImage.coloring26,
      LocalImage.coloring27,
      LocalImage.coloring28,
      LocalImage.coloring29,
      LocalImage.coloring30,
      LocalImage.coloring31,
      LocalImage.coloring32,
      LocalImage.coloring33,
      LocalImage.coloring34,
      LocalImage.coloring35,
    ];

    Random random = Random();

    return listColoringImage[random.nextInt(listColoringImage.length)];
  }

  void handleGetColoringUrl(int index) {
    switch (index) {
      case 38:
        if (_topicService.currentGrade.id == 1) {
          coloringUrl = LocalImage.b38l1;
        }
        break;
      case 40:
        if (_topicService.currentGrade.id == 1) {
          coloringUrl = LocalImage.b40l1;
        }
        break;
      case 6:
        if (_topicService.currentGrade.id == 2) {
          coloringUrl = LocalImage.b6l2;
        }
        break;
      case 65:
        if (_topicService.currentGrade.id == 2) {
          coloringUrl = LocalImage.b65l2;
        }
        break;
    }
  }

  void handleMyProgress() {
    final List<String>? idsReadingLearned = _preferencesManager
        .getStringList(KeySharedPreferences.idsReadingLearned);

    if (idsReadingLearned == null ||
        !idsReadingLearned.contains(readingId.toString())) {
      LibFunction.saveIds(
          key: KeySharedPreferences.idsReadingLearned, id: readingId);
      // _topicService.updateLessonCount(1);
    }

    final List<String>? idsTopicLearned =
    _preferencesManager.getStringList(KeySharedPreferences.idsTopicLearned);
    final bool isReadingEnd = Get.arguments[1] as bool;
    if ((idsTopicLearned == null ||
        !idsTopicLearned.contains(readingId.toString())) &&
        isReadingEnd) {
      LibFunction.saveIds(key: KeySharedPreferences.idsTopicLearned, id: -1);
      // _topicService.updateTopicCount(1);
    }

    // submitTimeDoingQuestion();
  }

  Future<void> backQuestion() async {
    if (AudioControl.instance.isPlaying) {
      await AudioControl.instance.stopAudio();
    }
    await LibFunction.effectExit();

    if (_questionIndex.value > 0) {
      _navigateToBackQuestion();
    } else {
      Get.back();
    }
  }

  Future<void> relearn() async {
    if (AudioControl.instance.isPlaying) {
      await AudioControl.instance.stopAudio();
    }
    await LibFunction.effectConfirmPop();
    _questionIndex.value = 0;
    _checkVideoPlugin(_unCompleteQuestions[questionIndex]);
    Get.offNamed(
      pluginRouteNames[_questionIndex.value],
      id: AppRoute.quizNestedRouteKey,
    );
  }

  void _navigateToNextQuestion() {
    isBack = false;
    _questionIndex.value += 1;

    _checkVideoPlugin(_unCompleteQuestions[questionIndex]);
    // stopReadingQuestion();
    _audioControl.restartPlayer();
    // _audioControl.setUsage();
    Get.offNamed(
      pluginRouteNames[_questionIndex.value],
      id: AppRoute.quizNestedRouteKey,
    );
  }

  void _navigateToBackQuestion() {
    isBack = true;
    _questionIndex.value -= 1;
    _checkVideoPlugin(_unCompleteQuestions[questionIndex]);
    // stopReadingQuestion();
    _audioControl.restartPlayer();
    // _audioControl.setUsage();
    Get.offNamed(
      pluginRouteNames[_questionIndex.value],
      id: AppRoute.quizNestedRouteKey,
    );
  }

  void _checkVideoPlugin(Question question) {
    // _minusStarOfReading(question);
    if (question.typeCode == 'V' || question.typeCode == "final_screen" || question.typeCode == "achieve_star") {
      LibFunction.pauseBackgroundSound();
      _isFullScreen.value = true;
      return;
    } else if (_isFullScreen.value) {
      _isFullScreen.value = false;
    }
    if (question.typeCode == "read" || question.typeCode == "L") {
      LibFunction.pauseBackgroundSound();
    } else if (BackgroundAudioControl.instance.isPlaying) {
      LibFunction.rePlayBackgroundSound();
    } else {
      LibFunction.playBackgroundSound(LocalAudio.soundInQuiz);
    }
  }

  void _getPlugin(List<Question> questionList) {
    for (final Question question in questionList) {
      // print(question);
      // print(question.typeCode);
      switch (question.typeCode) {
        case 'V':
          pluginRouteNames.add(AppRoute.video);
          break;
        case 'S':
          pluginRouteNames.add(AppRoute.singleChoice);
          break;
        case 'M':
          pluginRouteNames.add(AppRoute.multipleChoice);
          break;
        case 'X':
          pluginRouteNames.add(AppRoute.matched);
          break;
        case 'D':
          pluginRouteNames.add(AppRoute.fillWord);
          break;
        case 'L':
          pluginRouteNames.add(AppRoute.fillBlank);
          break;
        case 'P':
          pluginRouteNames.add(AppRoute.jigsawPuzzle);
          break;
        case 'T':
          pluginRouteNames.add(AppRoute.fillTable);
          break;
        case 'CWP':
          pluginRouteNames.add(AppRoute.crosswordPuzzle);
          break;
      // game
        case 'coloring':
          pluginRouteNames.add(AppRoute.coloring);
          break;
        case 'drawing':
          pluginRouteNames.add(AppRoute.drawing);
          break;
        case 'read':
          pluginRouteNames.add(AppRoute.read);
          break;
        case 'achieve_star':
          pluginRouteNames.add(AppRoute.achieveStar);
          break;
        case 'final_screen':
          pluginRouteNames.add(AppRoute.questionFinalScreen);
          break;
        default:
          break;
      }
    }
  }

  // count time use app
  Future<void> countTimeReading(double duration) async {
    if (!_topicService.isCaculator) return;
    _duration = duration;
    _timerReading = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration++;
    });
  }

  //count time doing quiz
  Future<void> countTimeDoingQuiz(double duration) async {
    if (!_topicService.isCaculator) return;
    _doQuizDuration = duration;
    _timerReading = Timer.periodic(const Duration(seconds: 1), (timer) {
      _doQuizDuration++;

      if(videoDuration > 0){
        if(_doQuizDuration.toInt() == videoDuration.toInt()){
          int loginRecordId = _preferencesManager.getInt(
            KeySharedPreferences.loginRecord+_userService.currentUser.userId.toString(),
          )!;
          // _userService.updateLoginRecord(loginRecordId, true, false, true);
        }
      }
      // print("do quiz duration: $_doQuizDuration");
    });
  }

  // save time doing quiz
  Future<void> saveTimeDoingQuizToStorage() async {
    try {
      _timerReading.cancel();
    } catch (e) {
      //
    }
    if (!_topicService.isCaculator) return;
    await _preferencesManager.putDouble(
      key: "${_userService.currentUser.id}_${readingId}_do_quiz_duration",
      value: _doQuizDuration,
    );
  }

  double getTimeDoingQuizFromStorage() {
    final double? duration = _preferencesManager.getDouble(
      "${_userService.currentUser.id}_${readingId}_do_quiz_duration",
    );
    if (duration != null) {
      return duration;
    }
    return 0.0; // unit minutes
  }

  Future<void> submitCompletedQuestion()async {
    //call api submit time doing question
    int loginRecordId = _preferencesManager.getInt(
      KeySharedPreferences.loginRecord + _userService.currentUser.userId.toString(),
    )!;
    // _userService.updateLoginRecord(loginRecordId, true, true, true);

}

  Future<void> saveTimeDurationToStorage() async {
    try {
      _timerReading.cancel();
    } catch (e) {
      //
    }
    if (!_topicService.isCaculator) return;

    await _preferencesManager.putDouble(
      key: "${_userService.currentUser.id}_${readingId}_duration",
      value: _duration,
    );
  }

  double getTimeDurationFromStorage() {
    final double? duration = _preferencesManager.getDouble(
      "${_userService.currentUser.id}_${readingId}_duration",
    );
    if (duration != null) {
      return duration;
    }
    return 0.0; // unit minutes
  }

  void saveReadingDurationToStorage(
      {required Map<String, dynamic> data}) async {
    const String keyReadingDuration = KeySharedPreferences.dataDuration;
    final String? readingDuration = _preferencesManager.getString(
      keyReadingDuration,
    );
    if (readingDuration != null) {
      // Cập nhật
      final decodeReadingDuration = List<Map<String, dynamic>>.from(
          jsonDecode(readingDuration)); // Mảng danh sách các read có duration
      for (final Map<String, dynamic> element in decodeReadingDuration) {
        if (element["read_topic"].toString() == data["read_topic"].toString() &&
            element["student_id"].toString() == data["student_id"].toString() &&
            element["date"].toString() == data["date"].toString()) {
          // remove old key
          element.assignAll({});
        }
      }
      decodeReadingDuration.add(data);
      await _preferencesManager.putString(
        key: keyReadingDuration,
        value: jsonEncode(
          decodeReadingDuration
              .where(
                (element) => element.isNotEmpty,
          )
              .toList(),
        ),
      );
    } else {
      // Thêm mới
      final List<Map<String, dynamic>> newData = [data];
      await _preferencesManager.putString(
        key: keyReadingDuration,
        value: jsonEncode(newData),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final double duration = getTimeDurationFromStorage();
        final double doQuizDuration = getTimeDoingQuizFromStorage();
        debugPrint("app in resumed");
        countTimeReading(duration);
        countTimeDoingQuiz(doQuizDuration);

        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        saveTimeDurationToStorage();
        saveTimeDoingQuizToStorage();
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        saveTimeDurationToStorage();
        saveTimeDoingQuizToStorage();
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        saveTimeDurationToStorage();
        saveTimeDoingQuizToStorage();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void readQuestion(question,options) async {
    try{
      _readingQuestionState.value = true;
      final file = await LibFunction.getSingleFile(question.audio);
      await Future.delayed(Duration(milliseconds: 200));
      await LibFunction.stopBackgroundSound();
      await _audioControl.setVolume(1.0);
      await _audioControl.setUsage();
      if (kIsWeb) {
        await _audioControl.playNetworkAudio(question.audio);
      }else{
        await _audioControl.playAudioFile(file.path);
      }
      var url = '';
      switch(question.typeCode){
        case 'S':
          url = LocalAudio.singleChoiceQuestion;
          break;
        case 'M':
          url = LocalAudio.multipleChoiceQuestion;
          break;
        case 'X':
          url = LocalAudio.matchingQuestion;
          break;
        case 'P':
          url = LocalAudio.dragAndDropQuestion;
          break;
        case 'D':
          url = LocalAudio.dragAndDropQuestion;
          break;
        case 'L':
          url = LocalAudio.fillBlankQuestion;
          break;
        default:
          break;
      }
      await Future.delayed(Duration(milliseconds: 200));
      await _audioControl.playLocalAudio(url: url);
      await LibFunction.rePlayBackgroundSound();
      // var speaking = question.question;
      // var key = 0;
      // if(options != null){
      //   for (var option in options) {
      //     speaking += "${question.type=='Single'?String.fromCharCode(97 + key):''}. ${option.value.option}.\n";
      //     key++;
      //   }
      // }
      // await flutterTts.speak(speaking);
    }catch(e){
      print("An error occurred: $e");
    }
  }

  Future<void> stopReadingQuestion() async {
    // await player.stop();
    await _audioControl.stopAudio();
  }

  void relearnQuestion() async {
    if (AudioControl.instance.isPlaying) {
      await AudioControl.instance.stopAudio();
    }
    await LibFunction.effectConfirmPop();
    _questionIndex.value = 2;
    _initCheckCorrectAnswer();

    Get.offNamed(
      pluginRouteNames[_questionIndex.value],
      id: AppRoute.quizNestedRouteKey,
    );
  }

  bool isFinalQuestion() {
    return _questionIndex.value == _unCompleteQuestions.length - 5;
  }

  @override
  void onClose() {
    saveTimeDurationToStorage();
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }
}
