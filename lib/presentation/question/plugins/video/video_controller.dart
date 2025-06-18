import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../data/core/local/share_preferences_manager.dart';
import '../../../../di/injection.dart';
import '../../../core/user_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../question_controller.dart';

class VideoController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final UserService _userService = Get.find<UserService>();
  final QuestionController? questionController = Get.isRegistered<QuestionController>()
        ? Get.find<QuestionController>()
        : null;
  VideoController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
  });
  late Timer _timerProgressBar;
  late VideoPlayerController? _videoController;
  final Rx<Duration> _videoPosition = Duration.zero.obs;
  final RxBool _isControlVisible = false.obs;
  final RxBool _isVideoPlaying = true.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isChooseLanguage = false.obs;
  final RxString _language = "vi".obs;
  late Uint8List? thumbVideo;
  final RxBool _isDownload = false.obs;
  final RxBool _isDownloading = false.obs;
  final RxInt _loadingProgress = 10.obs;
  final RxBool _loadingVideo = false.obs;
  late bool _initializedDone = false;
  final RxBool _isHasVideoMong = false.obs;
  late Duration videoDuration = Duration.zero;
  VideoPlayerController get videoController => _videoController!;
  bool get isLoading => _isLoading.value;
  Duration get videoPosition => _videoPosition.value;
  bool get isControlVisible => _isControlVisible.value;
  bool get isVideoPlaying => _isVideoPlaying.value;
  bool get isChooseLanguage => _isChooseLanguage.value;
  String get languague => _language.value;
  bool get isDownload => _isDownload.value;
  bool get isDownloading => _isDownloading.value;
  int get loadingProgress => _loadingProgress.value;
  bool get loadingVideo => _loadingVideo.value;
  bool get isHasVideoMong => _isHasVideoMong.value;

  late bool isVideoCompleted = false;

  set isDownload(bool value) {
    if (_isDownloading.value) return;
    _isDownload.value = value;
    _isDownloading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _language.listen((newLanguage) {
      _initData();
      return;
    });
    _initData();
    onChangeLanguage('vi');
  }

  Future<void> _initData() async {
    _initializedDone = false;
    try {
      if (question.video == "") {
        LibFunction.toast("timeout_video_initialize");
        Get.back();
        return;
      }

      setHasVideoMong();
      if (_language.value == 'vi') {
        // if (kIsWeb) {
        //   _videoController =
        //       VideoPlayerController.networkUrl(Uri.parse(question.video));
        // } else {
        //   final File video = await LibFunction.getSingleFile(question.video);
        //   _videoController = VideoPlayerController.file(video);
        // }
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(question.video));
      } else {
        if (!getLanguageVideoFromStorage()) {
          handleShowDownload(question.video_mong);
          return;
        } else {
          if (kIsWeb) {
            _videoController =
                VideoPlayerController.networkUrl(Uri.parse(question.video_mong));
          } else {
            final File videoMong =
                await LibFunction.getSingleFile(question.video_mong);
            _videoController = VideoPlayerController.file(videoMong);
          }
        }
      }
      await _videoController!.initialize().timeout(const Duration(seconds: 10));
      await _videoController!.play();
      _videoController!.addListener(_handleVideoStatus);
      _videoController!.addListener(_handleVideoPosition);

      _isLoading.value = false;

      _videoController!.addListener(_handlePlaybackError);
      _initializedDone = true;
    } on TimeoutException {
      LibFunction.toast("timeout_video_initialize");
      closeVideo();
    } catch (error) {
      debugPrint("Error on initialize remote video: $error");
      closeVideo();
    }

    videoDuration = _videoController!.value.duration;
    final questionController = this.questionController;
    if(questionController!=null){
      questionController.videoDuration = videoDuration.inSeconds;
    }
  }

  Future<void> changeSpeed(double speed) async {
    _videoController!.setPlaybackSpeed(speed);
    //_videoController!.setVolume(0.0);
    _videoController!.play();
  }

  Future<void> changeVolume(double volume) async {
    //_videoController!.setPlaybackSpeed(speed);
    _videoController!.setVolume(volume);
    _videoController!.play();
  }

  Future<void> closeVideo() async {
    await LibFunction.effectExit();
    await _disposeVideo();
    LibFunction.playBackgroundSound(LocalAudio.soundInApp);
    Get.back();
  }

  Future<void> completeLesson() async {
    if (isVideoCompleted == true) {
      await _disposeVideo();
      nextQuestion();
    } else {
      LibFunction.alert('please_finish_video');
    }
  }

  void toggleControl() {
    if (!getLanguageVideoFromStorage() && languague == "mo") {
      isDownload = true;
    } else {
      _isControlVisible.value = !_isControlVisible.value;
      if (_isControlVisible.value == false) _isChooseLanguage.value = false;
    }
  }

  void onPlayPress() {
    //_videoController!.setPlaybackSpeed(3.0);
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      _isControlVisible.value = true;
      _isVideoPlaying.value = false;
    } else if (_videoController!.value.duration > _videoPosition.value) {
      _videoController!.play();
      _isControlVisible.value = false;
      _isChooseLanguage.value = false;
      _isVideoPlaying.value = true;
    }
  }

  void _handleVideoPosition() {
    _videoPosition.value = _videoController!.value.position;
  }

  Future<void> _handlePlaybackError() async {
    final bool hasError = _videoController!.value.hasError;
    if (hasError) {
      LibFunction.toast("unstable_network_connection");
      _videoController!.dispose().then((value) => Get.back());
      _videoController = null;
    }
  }

  Future<void> onSeekVideo(double value) async {
    _videoPosition.value = Duration(seconds: value.toInt());

    await _videoController!.seekTo(videoPosition);
    //update video duration.
    await _videoController!.play();
  }

  Future<void> _handleVideoStatus() async {
    //update video position

    _videoPosition.value = _videoController!.value.position;

    //handle video finished
    if (_videoController!.value.duration == _videoController!.value.position) {
      _isVideoPlaying.value = false;
      isVideoCompleted = true;
      _isControlVisible.value = true;

      // controller.quizUseCases.isCurrentLessonComplete = true;
      // await _disposeVideo();
      // controller.nextQuestion();
    } else if (_videoController!.value.duration >
        _videoController!.value.position) {
      _isVideoPlaying.value = true;
      isVideoCompleted = false;
    }
    //handle error on play
    if (_videoController!.value.hasError) {
      LibFunction.toast('unstable_network_connection');
    }
  }

  Future<void> _disposeVideo() async {
    if (_videoController == null) return;
    _videoController!.removeListener(_handleVideoStatus);
    _videoController!.removeListener(_handleVideoPosition);
    _videoController!.removeListener(_handlePlaybackError);
    _videoController!.pause();
    await _videoController?.dispose();
  }

  Future<void> refreshVideo() async {
    _isControlVisible.value = false;
    _isChooseLanguage.value = false;
    _isVideoPlaying.value = true;
    _isLoading.value = true;
    isVideoCompleted = false;
    _initData();
  }

  void onPressLanguage() {
    _isChooseLanguage.value = !_isChooseLanguage.value;
  }

  Future<void> saveVideoLanguageToStorage(String language) async {
    if (languague == 'mo') {
      await _preferencesManager.putString(
        key: "${_userService.currentUser.id}_${readingId}_video_mo.json",
        value: question.video_mong,
      );
    } else {
      await _preferencesManager.putString(
        key: "${_userService.currentUser.id}_${readingId}_video_vi.json",
        value: question.video,
      );
    }
  }

  bool getLanguageVideoFromStorage() {
    final String? video = _preferencesManager.getString(
      "${_userService.currentUser.id}_${readingId}_video_mo.json",
    );

    if (video != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onChangeLanguage(String language) async {
    if(_initializedDone == true) {
      if(!getLanguageVideoFromStorage() && language == 'mo'){
        await _disposeVideo();
      }else{
        await refreshVideo();
      }
      _language.value = language;
    }
  }

  Future<void> handleShowDownload(String url) async {
    try {
      _isDownload.value = true;
      _loadingVideo.value = true;
      final mediaQueryData =
          // ignore: deprecated_member_use
          MediaQueryData.fromView(WidgetsBinding.instance.window);
      thumbVideo = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        maxWidth: mediaQueryData.size.width.ceil(),
        quality: 100,
      );
      _loadingVideo.value = false;
    } on TimeoutException {
      LibFunction.toast("timeout_video_initialize");
    } catch (error) {
      debugPrint("Error on initialize remote video: $error");
    }
  }

  void handleChangeProgressBar() async {
    _timerProgressBar = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_loadingProgress.value < 98 && _isDownloading.value) {
        _loadingProgress.value += 2;
      }
    });
  }

  void onPressDownload() async {
    try {
      await LibFunction.effectConfirmPop();
      _isDownloading.value = true;
      handleChangeProgressBar();

      // saveQuizDownloaded();

      await LibFunction.getSingleFile(question.video_mong);
      saveVideoLanguageToStorage('mo');
      _loadingProgress.value = 100;
      await Future.delayed(const Duration(milliseconds: 1000));
      // onPressLesson(reading: , );
      LibFunction.toast('download_success');
      await _disposeVideo();
      _initData();
    } catch (e) {
      LibFunction.toast('download_failed');
    }
    _isDownloading.value = false;
    _isDownload.value = false;
    _timerProgressBar.cancel();
    _loadingProgress.value = 10;
  }

  void setHasVideoMong() async {
    _isHasVideoMong.value = _isVideo(question.video_mong);
  }

  bool _isVideo(String url) {
    List<String> videoExtensions = [
      ".mp4",
      ".mkv",
      ".avi",
      ".mov",
      ".flv",
      ".wmv",
      ".webm"
    ];

    for (String extension in videoExtensions) {
      if (url.endsWith(extension)) {
        return true;
      }
    }
    return false;
  }

  // @override
  // void dispose() {

  //   super.dispose();
  // }
}
