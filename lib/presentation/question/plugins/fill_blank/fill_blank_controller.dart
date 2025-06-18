// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';

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
// import 'dart:html' as html;

const theSource = AudioSource.microphone;

class FillBlankController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final Function setIsFullScreen;
  final int readingId;
  final QuestionController questionController;

  FillBlankController({
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
  FlutterSoundPlayer get mPlayer => _mPlayer!;
  FlutterSoundRecorder get mRecorder => _mRecorder!;

  set isFullScreen(bool value) {
    _isFullScreen.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    mPath =
    "${readingId}_${question.questionId}_${DateTime.now().millisecondsSinceEpoch}.mp4";
    LibFunction.stopBackgroundSound();
    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited.value = true;
    });

    openTheRecorder().then((value) {
      _mRecorderIsInited.value = true;
    });

    questionController.readQuestion(question,null);
  }

  void onChangeInput({required String input}) {
    _text.value = input;
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

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    _hasPermissionMicrophone.value = true;
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(codec) && kIsWeb) {
      codec = Codec.opusWebM;
      mPath =
      '${readingId}_${question.questionId}_${DateTime.now().millisecondsSinceEpoch}.webm';
      if (!await _mRecorder!.isEncoderSupported(codec) && kIsWeb) {
        _mRecorderIsInited.value = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited.value = true;
  }

  void record() async {
    await LibFunction.effectConfirmPop();
    _mRecorder!
        .startRecorder(
      toFile: mPath,
      codec: codec,
      audioSource: theSource,
    )
        .then((value) {
      _isRecording.value = true;
    });
  }

  void stopRecorder() async {
    await LibFunction.effectConfirmPop();
    final String? value = await _mRecorder!.stopRecorder();
    pathAudio = value ?? '';
    _isRecording.value = false;
    _mplaybackReady.value = true;
    _isCompleted.value = true;
  }

  void play() async {
    await LibFunction.effectConfirmPop();
    assert(_mPlayerIsInited.value &&
        _mplaybackReady.value &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);

    for (final Rx<Setting> element in _userService.settings) {
      if (element.value.key == "vocal_volume") {
        _mPlayer!.setVolume(double.parse(element.value.value) / 10);
      }
    }

    _mPlayer!
        .startPlayer(
        fromURI: mPath,
        codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          _isPlaying.value = false;
        })
        .then((value) {
      _isPlaying.value = true;
    });
  }

  void stopPlayer() async {
    await LibFunction.effectConfirmPop();
    _mPlayer!.stopPlayer().then((value) {
      _isPlaying.value = false;
    });
  }

  void deleteRecord() async {
    await LibFunction.effectConfirmPop();
    pathAudio = "";
    _isFilledText.value = true;
    _mplaybackReady.value = false;
  }

  @override
  void onClose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.onClose();
  }

  Future<void> onSubmitPress() async {
    if (Get.isDialogOpen!) return;

    Uint8List? bytes;

    try {
      if (pathAudio.isNotEmpty) {

        // Non-web logic to read file as bytes
        final File file = File(pathAudio);
        bytes = await file.readAsBytes();

        if (bytes != null) {
          final fileName = pathAudio.split('/').last; // Use '/' as a separator for web
          await LibFunction.putFileUintList(fileName, bytes);
        } else {
          throw Exception('Failed to convert file to bytes.');
        }
      }

      if (_text.value.isEmpty && pathAudio.isEmpty) {
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

      quizUseCases.submitQuestion(
        readingId: readingId,
        questionId: question.questionId,
        isCorrect: true,
        attempt: question.attempt,
        duration: questionController.getTimeDoingQuizFromStorage(),
        isCompleted: isFinalQuestion,
        data: {
          "isFile": !_isFilledText.value && pathAudio.isNotEmpty,
          "question_answer[${question.questionId}]":
          !_isFilledText.value && pathAudio.isNotEmpty
              ? pathAudio.split('/').last
              : _text.value,
        },
      );

      questionController.updateCheckCorrectAnswer(questionController.questionIndex, true);
      nextQuestion();

      // quizUseCases.submitQuestion(
      //   readingId: readingId,
      //   questionId: question.questionId,
      //   isCorrect: true,
      //   attempt: question.attempt,
      //   data: {
      //     "isFile": !_isFilledText.value && pathAudio.isNotEmpty,
      //     "question_answer[${question.questionId}]":
      //     !_isFilledText.value && pathAudio.isNotEmpty
      //         ? pathAudio.split('/').last
      //         : _text.value,
      //   },
      // );
      //
      // questionController.updateCheckCorrectAnswer(questionController.questionIndex, true);
      // nextQuestion();
    } catch (e) {
      print('Error processing audio file: $e');
    }
  }

  Future<Uint8List> fileToUint8List(File file) async {
    List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }
}
