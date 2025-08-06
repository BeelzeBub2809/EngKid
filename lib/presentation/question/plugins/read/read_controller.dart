// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

const theSource = AudioSource.microphone;

class ReadController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final Function setIsFullScreen;
  final int readingId;

  ReadController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.setIsFullScreen,
    required this.readingId,
  });

  final UserService _userService = Get.find<UserService>();

  late Codec codec = Codec.aacMP4;
  late String mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  final RxBool _mPlayerIsInited = false.obs;
  final RxBool _mRecorderIsInited = false.obs;
  final RxBool _mplaybackReady = false.obs;
  final RxBool _hasPermissionMicrophone = false.obs;
  final RxBool _isCompleted = false.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isStarted = false.obs;

  bool get hasPermissionMicrophone => _hasPermissionMicrophone.value;

  bool get isCompleted => _isCompleted.value;
  bool get mPlayerIsInited => _mPlayerIsInited.value;
  bool get mRecorderIsInited => _mRecorderIsInited.value;
  bool get mplaybackReady => _mplaybackReady.value;
  bool get isRecording => _isRecording.value;
  bool get isPlaying => _isPlaying.value;
  bool get isStarted => _isStarted.value;
  FlutterSoundPlayer get mPlayer => _mPlayer!;
  FlutterSoundRecorder get mRecorder => _mRecorder!;

  @override
  void onInit() {
    super.onInit();
    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited.value = true;
    });

    openTheRecorder().then((value) {
      _mRecorderIsInited.value = true;
    });
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
      mPath = 'tau_file.webm';
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
    _mRecorder!.stopRecorder().then((value) {
      //var url = value;
      _isRecording.value = false;
      _mplaybackReady.value = true;
      _isCompleted.value = true;
    });
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

  Future<void> onSubmit() async {
    nextQuestion();
  }

  void onPressStart() async {
    await LibFunction.effectConfirmPop();
    _isStarted.value = true;
  }

  @override
  void onClose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.onClose();
  }
}
