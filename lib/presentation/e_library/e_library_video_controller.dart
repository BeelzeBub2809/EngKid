import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:video_player/video_player.dart';

import '../../domain/core/entities/elibrary/elibrary.dart';
import '../core/elibrary_service.dart';
import '../core/network_service.dart';

class ElibraryVideoController extends GetxController {
  final Elibrary book;
  final ElibraryService elibraryService = Get.find<ElibraryService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  ElibraryVideoController({
    required this.book,
  });
  late VideoPlayerController? _videoController;
  final Rx<Duration> _videoPosition = Duration.zero.obs;
  final RxBool _isControlVisible = false.obs;
  final RxBool _isVideoPlaying = true.obs;
  final RxBool _isLoading = true.obs;
  // final RxBool _isFullScreenVideo = false.obs;

  VideoPlayerController get videoController => _videoController!;
  bool get isLoading => _isLoading.value;
  Duration get videoPosition => _videoPosition.value;
  bool get isControlVisible => _isControlVisible.value;
  bool get isVideoPlaying => _isVideoPlaying.value;

  late bool isVideoCompleted = false;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    try {
      if (book.reading_video == "") {
        LibFunction.toast("timeout_video_initialize");
        Get.back();
        return;
      }
      final File video = await LibFunction.getSingleFile(book.reading_video);
      print('videoPath : ${video}');

      _videoController = VideoPlayerController.file(video);

      await _videoController!.initialize().timeout(const Duration(seconds: 10));
      await _videoController!.play();
      _videoController!.addListener(_handleVideoStatus);
      _videoController!.addListener(_handleVideoPosition);

      _isLoading.value = false;

      _videoController!.addListener(_handlePlaybackError);
    } on TimeoutException {
      LibFunction.toast("timeout_video_initialize");
      closeVideo();
    } catch (error) {
      debugPrint("Error on initialize remote video: $error");
      closeVideo();
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

  Future<void> completeLesson(int studentId) async {
    if (isVideoCompleted == true) {
      if (_networkService.networkConnection.value) {
        await elibraryService.updateStatus(studentId, book.id, 1);
      }
      if (elibraryService.bookList[elibraryService.bookIndex].isActive == false) {
        elibraryService.bookList[elibraryService.bookIndex] = elibraryService
            .bookList[elibraryService.bookIndex]
            .copyWith(isActive: true);
        elibraryService.completedBook = elibraryService.completedBook + 1;
        elibraryService.completedBook =
            min(elibraryService.completedBook, elibraryService.totalBook);
      }
      await _disposeVideo();

      Get.back();
    } else {
      LibFunction.alert('please_finish_video');
    }
  }

  void toggleControl() {
    _isControlVisible.value = !_isControlVisible.value;
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
    _isVideoPlaying.value = true;
    _isLoading.value = true;
    isVideoCompleted = false;
    _initData();
  }

// @override
// void dispose() {

//   super.dispose();
// }
}
