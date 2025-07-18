import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/setting/setting.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_change_acc.dart';
import 'package:EngKid/widgets/dialog/dialog_delete.dart';
import 'package:EngKid/widgets/dialog/dialog_downloadall.dart';
import 'package:EngKid/widgets/dialog/dialog_downloadwarning.dart';
import 'package:EngKid/widgets/dialog/dialog_select_download_language.dart';
import 'package:EngKid/widgets/dialog/dialog_warning_time.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

import '../../widgets/dialog/toast_dialog.dart';

class ReadingSpaceController extends GetxController with WidgetsBindingObserver {
  ReadingSpaceController();

  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();

  late VideoPlayerController? _videoController;
  final ScrollController scrollControllerTopic = ScrollController();
  final ScrollController scrollControllerLesson = ScrollController();
  final ScrollController scrollControllerDownloadLesson = ScrollController();
  late Reading readingData;
  late int indexReading;
  late Timer _timerProgressBar;
  late Timer _timerUseApp;
  late int _remainingTime = 0;
  late Uint8List? thumbVideo;

  final RxList<Topic> _topics = <Topic>[].obs;
  final RxList<Reading> _readings = <Reading>[].obs;
  final RxBool _isDownload = false.obs;
  final RxBool _isDownloading = false.obs;
  final RxInt _loadingProgress = 10.obs;
  final RxBool _loadingVideo = false.obs;
  final RxList<bool> _isDownloaded = RxList<bool>.filled(2000, false);
  final RxList<bool> _isVideoDownloaded = RxList<bool>.filled(2000, false);
  final RxList<bool> _isMultipleDownloading = RxList<bool>.filled(2000, false);
  final RxList<bool> _isHasVideoMong = RxList<bool>.filled(2000, false);
  final RxList<bool> _isCheckedMong = RxList<bool>.filled(2000, false);
  final RxList<bool> _isDownloadedVideoMong = RxList<bool>.filled(2000, false);
  final RxBool _readingSequence = true.obs;
  final RxBool _isSelectedMong = false.obs;
  final RxBool _isDownloadedScreen = false.obs;
  final RxBool _isCheckedLanguage = false.obs;
  final RxBool _isCheckedAllMong = false.obs;
  final RxString _selectLanguage = "None".obs;
  final RxInt _topicIndex = 0.obs;

  final RxBool _isCheckAll = false.obs;

  bool get isDownload => _isDownload.value;

  bool get isDownloading => _isDownloading.value;

  bool get isCheckedLanguage => _isCheckedLanguage.value;

  int get loadingProgress => _loadingProgress.value;

  bool get loadingVideo => _loadingVideo.value;

  VideoPlayerController get videoController => _videoController!;

  List get isDownloaded => _isDownloaded.value;

  List get isVideoDownloaded => _isVideoDownloaded.value;

  List get isMultipleDownloading => _isMultipleDownloading.value;

  List get isHasVideoMong => _isHasVideoMong.value;

  bool get isDownloadedScreen => _isDownloadedScreen.value;

  String get selectedLanguage => _selectLanguage.value;

  List get isCheckedMong => _isCheckedMong.value;

  bool get isCheckedAllMong => _isCheckedAllMong.value;

  bool get isSelectedMong => _isSelectedMong.value;

  List get isDownloadedVideoMong => _isDownloadedVideoMong.value;

  bool get ReadingSequence => _readingSequence.value;

  List<Topic> get topics => _topics.value;

  List<Reading> get readings => _readings.value;

  int get topicIndex => _topicIndex.value;

  bool get isCheckAll => _isCheckAll.value;

  set isDownload(bool value) {
    if (_isDownloading.value) return;
    _isDownload.value = value;
    _isDownloading.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // _userService.getReadingSequenceSetting();
    _readingSequence.value =
        _userService.readingSequenceSetting.readingSequenceSetting;
    WidgetsBinding.instance.addObserver(this);
    // get topics
    final res = await _topicService.getTopicByGrade();
    _topics.value = res;
    _topicIndex.value = 0;
    final readingRes =await _topicService.getReadingByTopic(_topicIndex.value + 1);
    _readings.value = readingRes;
  }

  Future<void> onPressLesson(
      {required Reading reading, required int index}) async {
    await LibFunction.effectConfirmPop();
    readingData = reading;
    indexReading = index;

    var currentQuiz = Quiz(
      reading: QuizReading(
        name: reading.name,
        id: reading.id,
        thumImg: reading.thumImg,
        background: reading.background,
        video: reading.readingVideo,
        videoMong: '',
        questionCount: reading.totalQuiz == 0
            ? const Count()
            : Count(
                total: reading.totalQuiz,
                complete: reading.totalCompleteQuiz,
              ),

      ),
      questions: [
        const Question(
          questionId: 1,
          type: 'Single Choice',
          typeCode: 'S',
          question: "What is the capital of France?",
          options: [
            Option(
              optionId: 1,
              option: "Paris",
              isCorrect: '1',
              image: "",
            ),
            Option(
              optionId: 2,
              option: "London",
              isCorrect: '0',
              image: "",
            ),
            Option(
              optionId: 3,
              option: "Berlin",
              isCorrect: '0',
              image: "",
            ),
          ],
          achievedMark: 0.0,
          background: "",
          audio: "",
        ),
      ],

    );
    startLearning(currentQuiz, index);
    // setHasVideoMong();
    // if (!getQuizsFromStorage()) {
    //   await handleShowDownload(reading.readingVideo);
    //   debugPrint("check download : $reading.readingVideo");
    // } else {
    //   // check lock
    //   if (getPathLessonStatus(index) == LocalImage.lessonLocked &&
    //       _topicService.isCaculator) {
    //     LibFunction.toast("lock_lesson");
    //     return;
    //   }
    //   // kiểm tra ngôn ngữ
    //   late String language = "vi";
    //   final Rx<Setting>? tmp = _userService.settings
    //       .firstWhereOrNull((element) => element.value.key == 'language');
    //   if (tmp != null) {
    //     language = tmp.value.value;
    //   }
    //   if (_topicService.currentQuiz.language != language) {
    //     await handleShowDownload(reading.readingVideo);
    //     return;
    //   }
    //   // handle count down
    //   final int timeLimit = getTimeLimitFromStorage();
    //   if (timeLimit > 0) {
    //     countdownTimerUseApp(timeLimit);
    //     // start learn
    //     if (_topicService.isCaculator) {
    //       await updateAttempt(_topicService.currentQuiz);
    //     }
    //     startLearning(_topicService.currentQuiz, index);
    //   } else {
    //     try {
    //       _timerUseApp.cancel();
    //     } catch (e) {
    //       //
    //     }
    //
    //     Get.dialog(
    //       DialogWarningTime(
    //           timer: _topicService.currentGrade.timeLimit,
    //           onTapContinue: () async {
    //             // start learn
    //             if (_topicService.isCaculator) {
    //               await updateAttempt(_topicService.currentQuiz);
    //             }
    //             startLearning(_topicService.currentQuiz, index);
    //           }),
    //       barrierDismissible: false,
    //       barrierColor: null,
    //     );
    //   }
    // }
  }

  void startLearning(Quiz quiz, int index) {
    Get.toNamed(
      AppRoute.lesson,
      arguments: [
        quiz, // current reading
        readings.length - 1 ==
            index, // reading end
        readings[index]
      ],
    );
  }

  Future<void> updateAttempt(Quiz quiz) async {
    // mỗi lần vào học sẽ tăng một lần cố gắng lên
    // await Future.forEach(quiz.questions, (Question element) async {
    //   await _topicService.updateAttempt(
    //     element.questionId,
    //     double.parse(
    //       element.achievedMark.toString(),
    //     ),
    //   );
    // });
  }

  String getPathLessonStatus(int index) {
    if (_readings[index].maxAchievedStars == _readings[index].stars) {
      return LocalImage.lessonCompleted;
    }
    if (index == 0) {
      return LocalImage.lessonProgress;
    }

    return LocalImage.lessonProgress;
  }

  // Tải bài học
  void onPressDownload() async {
    try {
      await LibFunction.effectConfirmPop();
      _isDownloading.value = true;
      handleChangeProgressBar();
      late String language = "vi";
      final Rx<Setting>? tmp = _userService.settings
          .firstWhereOrNull((element) => element.value.key == 'language');
      if (tmp != null) {
        language = tmp.value.value;
      }

      // final Quiz datafile = await _topicService.getQuiz(readingData.id);
      // _topicService.currentQuiz = datafile.copyWith(language: language);

      // await saveReadingToCache(datafile.reading);
      // debugPrint("check download1 : ${datafile.reading}");

      // await saveQuestionsToCache(datafile.questions);
      // await _topicService.saveQuizsToStorage();
      // saveQuizDownloaded();

      _loadingProgress.value = 100;
      await Future.delayed(const Duration(milliseconds: 1000));
      // onPressLesson(reading: , );
      LibFunction.toast('download_success');
      onPressLesson(reading: readingData, index: indexReading);
      readingData = const Reading();
      indexReading = -1;
    } catch (e) {
      LibFunction.toast('download_failed');
    }
    _isDownloading.value = false;
    _isDownload.value = false;
    _timerProgressBar.cancel();
    _loadingProgress.value = 10;
  }

  Future<void> saveReadingToCache(QuizReading quizReading) async {
    try {
      await LibFunction.getSingleFile(quizReading.thumImg);
      await LibFunction.getSingleFile(quizReading.background);
      await LibFunction.getSingleFile(quizReading.video);
    } catch (e) {
      //
    }
  }

  Future<void> saveQuestionsToCache(List<Question> questions) async {
    try {
      await Future.forEach(questions, (Question question) async {
        if (question.background != "") {
          await LibFunction.getSingleFile(question.background);
        }
        if (question.audio != "") {
          await LibFunction.getSingleFile(question.audio);
        }
        await Future.forEach(question.options, (Option option) async {
          if (option.image != "") {
            await LibFunction.getSingleFile(option.image);
          }
        });
      });
    } catch (e) {
      //
    }
  }

  Future<void> removeQuestionsFromCache(List<Question> questions) async {
    try {
      await Future.forEach(questions, (Question question) async {
        if (question.background != "") {
          await LibFunction.removeFileCache(question.background);
        }
        if (question.audio != "") {
          await LibFunction.removeFileCache(question.audio);
        }
        await Future.forEach(question.options, (Option option) async {
          if (option.image != "") {
            await LibFunction.removeFileCache(option.image);
          }
        });
      });
    } catch (e) {
      //
    }
  }

  bool getQuizsFromStorage() {
    final String? quizs = _preferencesManager.getString(
      "${_userService.currentUser.id}_${readingData.id}_datafile.json",
    );

    if (quizs != null) {
      final decodeTopicReadings = Quiz.fromJson(jsonDecode(quizs));
      _topicService.currentQuiz = decodeTopicReadings;
      return true;
    } else {
      return false;
    }
  }

  void handleChangeProgressBar() async {
    _timerProgressBar = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_loadingProgress.value < 98 && _isDownloading.value) {
        _loadingProgress.value += 2;
      }
    });
  }

  void saveQuizDownloaded() async {
    LibFunction.saveIds(
        key: KeySharedPreferences.idsDownloaded, id: readingData.id);
  }

  //

  // countdown time use app
  Future<void> countdownTimerUseApp(int timeLimit) async {
    if (!_topicService.isCaculator) return;
    _remainingTime = timeLimit;
    if (_remainingTime > 0) {
      _timerUseApp = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime == 0) {
            try {
              timer.cancel();
              _timerUseApp.cancel();
            } catch (e) {
              debugPrint("error cancel timer: $e");
            }
          }

          if (_remainingTime == 25 * 60) {
            int loginRecordId = _preferencesManager.getInt(
              KeySharedPreferences.loginRecord +
                  _userService.currentUser.id.toString(),
            )!;
            // _userService.updateLoginRecord(loginRecordId, false, false, true);
          }
        } else {
          try {
            timer.cancel();
            _timerUseApp.cancel();
          } catch (e) {
            debugPrint("error cancel timer: $e");
          }
          saveTimeLimitToStorage();
          if (Get.isDialogOpen!) {
            return;
          }
          Get.dialog(
            DialogWarningTime(
                timer: _topicService.currentGrade.timeLimit,
                onTapContinue: () {}),
            barrierDismissible: false,
            barrierColor: null,
          );
        }
      });
    }
  }

  Future<void> saveTimeLimitToStorage() async {
    try {
      _timerUseApp.cancel();
    } catch (e) {
      //
    }
    if (!_topicService.isCaculator) return;
    await _preferencesManager.putInt(
        key:
        "${_topicService.currentGrade.id}_${LibFunction
            .startOfDateNow()
            .microsecondsSinceEpoch}_timeLimit",
        value: _remainingTime);
  }

  int getTimeLimitFromStorage() {
    try {
      final int? timeLimit = _preferencesManager.getInt(
          "${_topicService.currentGrade.id}_${LibFunction
              .startOfDateNow()
              .microsecondsSinceEpoch}_timeLimit");
      if (timeLimit != null) {
        return timeLimit;
      }
      return int.parse(_topicService.currentGrade.timeLimit) *
          60; // unit minutes
    } catch (e) {
      return 30 * 60;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final int timeLimit = getTimeLimitFromStorage();
        debugPrint("app in resumed");
        if (timeLimit > 0) {
          countdownTimerUseApp(timeLimit);
        }
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        saveTimeLimitToStorage();
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        saveTimeLimitToStorage();
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        saveTimeLimitToStorage();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> handleShowDownload(String url) async {
    try {
      _isDownload.value = true;
      _loadingVideo.value = true;
      final mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);
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

  @override
  void onClose() {
    // save timer use app to local
    saveTimeLimitToStorage();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

    void handleShowDownloadAll(ReadingSpaceController controller) {
    checkIsDownloaded();
    setIsVideoDownloaded();
    handleChangeDownloadedScreen(false);
    setHasVideoMong();
    setIsDownloadedVideoMong();
    _isMultipleDownloading.value = RxList<bool>.filled(2000, false);
    _isCheckAll.value = false;
    Get.dialog(
      DialogDownloadAll(
        controller: controller,
      ),
      barrierDismissible: false,
      barrierColor: null,
    );
  }

  void checkIsDownloaded() {
    for (Reading reading in _topicService.topicReadings.topicReadings
        .readings) {
      String? isVideoDownloaded = _preferencesManager.getString(
        "${_userService.currentUser.id}_${reading.id}_datafile.json",
      );
      if (isVideoDownloaded != null) {
        _isDownloaded[reading.id] = true;
      }
      else {
        _isDownloaded[reading.id] = false;
      }
    }
  }

  void setIsDownloadedVideoMong() {
    for (Reading reading
    in _topicService.topicReadings.topicReadings.readings) {
      String? isVideoDownloaded = _preferencesManager.getString(
        "${_userService.currentUser.id}_${reading.id}_video_mo.json",
      );
      if (isVideoDownloaded != null) {
        _isDownloadedVideoMong[reading.id] = true;
      } else {
        _isDownloadedVideoMong[reading.id] = false;
      }
    }
  }

  void setIsVideoDownloaded() {
    for (Reading reading
    in _topicService.topicReadings.topicReadings.readings) {
      String? isVideoDownloaded = _preferencesManager.getString(
        "${_userService.currentUser.id}_${reading.id}_datafile.json",
      );
      if (isVideoDownloaded != null) {
        _isVideoDownloaded[reading.id] = true;
      } else {
        _isVideoDownloaded[reading.id] = false;
      }
    }
  }

  void handleDownloadStatusChange(int readingId, bool currentStatus) {
    _isDownloaded[readingId] = !currentStatus;
  }

  void handleDelete() async {
    bool isContinue = false;
    await Get.dialog(
      DialogDelete(
          onTapContinue: () async {
            //start delete
            isContinue = true;
            // Get.dialog(ModalBarrier(dismissible: false, color: Colors.transparent));
            Get.dialog(LoadingDialog());
            showToastWidget(ToastDialog("delete_4".tr),
                duration: const Duration(seconds: 2));
            for (Reading reading in _topicService.topicReadings.topicReadings
                .readings) {
              // print("Reading download status");
              // print(reading.id);
              // print(_isVideoDownloaded[reading.id]);
              if (_isDownloaded[reading.id] == true) {
                await deleteQuizFromStorage(reading.id);
                // final Quiz datafile = await _topicService.getQuiz(reading.id);
                // await LibFunction.removeFileCache(datafile.reading.thumImg);
                // await LibFunction.removeFileCache(datafile.reading.background);
                // await LibFunction.removeFileCache(datafile.reading.video);
                // await LibFunction.removeFileCache(datafile.reading.videoMong);
                // await removeQuestionsFromCache(datafile.questions);

                _isVideoDownloaded[reading.id] = false;
                _isDownloaded[reading.id] = false;
                _topicService.downloadAllReadingList.remove(reading);
                _isDownloadedVideoMong[reading.id] = false;
              }
            }
            await Future.delayed(const Duration(milliseconds: 2000));
            showToastWidget(ToastDialog("delete_3".tr),
                duration: const Duration(seconds: 3));
            Get.back();
          }),
      barrierDismissible: false,
      barrierColor: null,
    );
    if (isContinue) {
      // Get.back();

      // await Future.delayed(const Duration(milliseconds: 2000));
      // showToastWidget(ToastDialog("delete_3".tr), duration: const Duration(seconds: 3));
      // Get.back();
    }
  }

  void handleDeleteSingle(Reading reading) async {
    bool isContinue = false;
    await Get.dialog(
      DialogDelete(
          onTapContinue: () async {
            //start delete
            isContinue = true;
            Get.dialog(LoadingDialog());
            showToastWidget(ToastDialog("delete_4".tr),
                duration: const Duration(seconds: 2));
            if (_isDownloaded[reading.id] == true) {
              await deleteQuizFromStorage(reading.id);
              // final Quiz datafile = await _topicService.getQuiz(reading.id);
              // await LibFunction.removeFileCache(datafile.reading.thumImg);
              // await LibFunction.removeFileCache(datafile.reading.background);
              // await LibFunction.removeFileCache(datafile.reading.video);
              // await LibFunction.removeFileCache(datafile.reading.videoMong);
              // await removeQuestionsFromCache(datafile.questions);
              // await LibFunction.removeFileCache(datafile.reading.video);
              _isVideoDownloaded[reading.id] = false;
              _isDownloaded[reading.id] = false;
              _isVideoDownloaded[reading.id] = false;
              _topicService.downloadAllReadingList.remove(reading);
              _isDownloadedVideoMong[reading.id] = false;
            }
            await Future.delayed(const Duration(milliseconds: 2000));
            showToastWidget(ToastDialog("delete_3".tr),
                duration: const Duration(seconds: 3));
            Get.back();
          }),
      barrierDismissible: false,
      barrierColor: null,
    );
    if (isContinue) {
      // Get.back();
      // Get.dialog(ModalBarrier(dismissible: false, color: Colors.transparent));
      // showToastWidget(ToastDialog("delete_4".tr), duration: const Duration(seconds: 2 ));
      // await Future.delayed(const Duration(milliseconds: 2000));
      // showToastWidget(ToastDialog("delete_3".tr), duration: const Duration(seconds: 3));
      // Get.back();
    }
  }

  void handleDownload() async {
    bool isContinue = false;
    await Get.dialog(
      DialogDownloadWarning(onTapContinue: () async {
        //start delete
        for (Reading reading
        in _topicService.topicReadings.topicReadings.readings) {
          if (_isDownloaded[reading.id] == true) {
            String? isVideoDownloaded = _preferencesManager.getString(
              "${_userService.currentUser.id}_${reading.id}_datafile.json",
            );
            if (isVideoDownloaded == null) {
              _isMultipleDownloading[reading.id] = true;
            }
          }
        }
        for (Reading reading
        in _topicService.topicReadings.topicReadings.readings) {
          String? isVideoDownloaded = _preferencesManager.getString(
            "${_userService.currentUser.id}_${reading.id}_datafile.json",
          );

          if (_isDownloaded[reading.id] == true && isVideoDownloaded == null) {
            // final Quiz datafile = await _topicService.getQuiz(reading.id);
            _isMultipleDownloading[reading.id] = true;

            // await saveReadingToCache(datafile.reading);
            //
            // await saveQuestionsToCache(datafile.questions);
            // await _preferencesManager.putString(
            //   key: "${_userService.currentUser.id}_${reading.id}_datafile.json",
            //   value: jsonEncode(datafile.toJson()),
            // );

            if (_isCheckedMong[reading.id] == true &&
                _isHasVideoMong[reading.id] &&
                !_isDownloadedVideoMong[reading.id]) {
              // await LibFunction.getSingleFile(datafile.reading.videoMong);
              // await _preferencesManager.putString(
              //     key:
              //     "${_userService.currentUser.id}_${reading.id}_video_mo.json",
              //     value: datafile.reading.videoMong);
              _isDownloadedVideoMong[reading.id] = true;
            }

            _isMultipleDownloading[reading.id] = false;
            _isVideoDownloaded[reading.id] = true;
            _topicService.downloadAllReadingList.remove(reading);
            _isDownloaded[reading.id] = true;

            // print("Reading download status");
            // print(reading.id);
            // print(_isVideoDownloaded[reading.id]);
          }
        }
      }),
      barrierDismissible: false,
      barrierColor: null,
    );

    // print("Video downloaded List");
    // print(_isVideoDownloaded);
  }

  Future<void> deleteQuizFromStorage(int readingId) async {
    // Construct the key for the quiz you want to delete
    String quizKey =
        "${_userService.currentUser.id}_${readingId}_datafile.json";
    String quizVideoMong =
        "${_userService.currentUser.id}_${readingId}_video_mo.json";
    // Use _preferencesManager to remove the quiz from storage
    await _preferencesManager.remove(quizKey);
    await _preferencesManager.remove(quizVideoMong);
  }

  void handleCheckAll() {
    _isCheckAll.value = !_isCheckAll.value;
    _isDownloaded.value = RxList<bool>.filled(2000, _isCheckAll.value);
  }

  void handleChangeDownloadedScreen(bool value) {
    _isDownloadedScreen.value = value;

    _topicService.downloadAllReadingList.clear();
    for (Reading reading
    in _topicService.topicReadings.topicReadings.readings) {
      if (_isVideoDownloaded[reading.id] == value) {
        _topicService.downloadAllReadingList.add(reading);
      }
    }
  }

  void handleSelectLanguageAll(ReadingSpaceController controller,
      int readingId) async {
    if (!_isDownloadedScreen.value) {
      bool isContinue = false;

      _isSelectedMong.value =
      readingId == 0 ? _isCheckedAllMong.value : _isCheckedMong[readingId];
      await Get.dialog(
        DialogSelectDownloadLanguage(
          onTapContinue: () async {
            //start change language
            isContinue = true;
            readingId == 0
                ? applyAllSelectedLanguage()
                : applySingleSelectedLanguage(readingId);
          },
          controller: controller,
          readingId: readingId,
          continueText: 'apply'.tr,
        ),
        barrierDismissible: false,
        barrierColor: null,
      );

      if (isContinue) {
        // Get.back();
        Get.dialog(
            const ModalBarrier(dismissible: false, color: Colors.transparent));
        // showToastWidget(ToastDialog("Đang tải ngôn ngữ"), duration: const Duration(seconds: 2 ));
        // await Future.delayed(const Duration(milliseconds: 2000));
        // showToastWidget(ToastDialog("Đã tải ngôn ngữ".tr), duration: const Duration(seconds: 3));
        Get.back();
      }
    } else {
      bool isContinue = false;

      await Get.dialog(
        DialogSelectDownloadLanguage(
          onTapContinue: () async {
            //start change language
            isContinue = true;
            if (_isSelectedMong.value) {
              // Get.dialog(ModalBarrier(dismissible: false, color: Colors.transparent));
              Get.dialog(const LoadingDialog());
              showToastWidget(ToastDialog("language_downloading".tr),
                  duration: const Duration(seconds: 2));
              if (readingId != 0) {
                // final Quiz datafile = await _topicService.getQuiz(readingId);
                if (!_isDownloadedVideoMong[readingId]) {
                  // await LibFunction.getSingleFile(datafile.reading.videoMong);
                  // await _preferencesManager.putString(
                  //     key:
                  //     "${_userService.currentUser.id}_${readingId}_video_mo.json",
                  //     value: datafile.reading.videoMong);
                  _isDownloadedVideoMong[readingId] = true;
                  await Future.delayed(const Duration(milliseconds: 2000));
                  Get.back();
                  showToastWidget(ToastDialog("language_download_done".tr),
                      duration: const Duration(seconds: 2));
                } else {
                  await Future.delayed(const Duration(milliseconds: 2000));
                  Get.back();
                  showToastWidget(ToastDialog("languague_download_error_1".tr),
                      duration: const Duration(seconds: 2));
                }
              } else {
                for (Reading reading in _topicService.downloadAllReadingList) {
                  // final Quiz datafile = await _topicService.getQuiz(reading.id);
                  if (_isHasVideoMong[reading.id] &&
                      !_isDownloadedVideoMong[reading.id]) {
                    // await LibFunction.getSingleFile(datafile.reading.videoMong);
                    // await _preferencesManager.putString(
                    //     key:
                    //     "${_userService.currentUser.id}_${reading.id}_video_mo.json",
                    //     value: datafile.reading.videoMong);
                    _isDownloadedVideoMong[reading.id] = true;
                  }
                }
                await Future.delayed(const Duration(milliseconds: 2000));
                Get.back();
                showToastWidget(ToastDialog("language_download_done".tr),
                    duration: const Duration(seconds: 2));
              }
            } else {
              Get.dialog(const ModalBarrier(
                  dismissible: false, color: Colors.transparent));
              showToastWidget(ToastDialog("languague_download_error_2".tr),
                  duration: const Duration(seconds: 2));
              Get.back();
            }
          },
          controller: controller,
          readingId: readingId,
          continueText: 'download'.tr,
        ),
        barrierDismissible: false,
        barrierColor: null,
      );

      if (isContinue) {
        // Get.back();
        // Get.back();
      }
    }
  }

  void handleChangeLanguageDownload(String languageCode) {
    switch (languageCode) {
      case "mo":
        _isSelectedMong.value = !_isSelectedMong.value;
        break;
    }
  }

  void applyAllSelectedLanguage() {
    // print('ngu');
    _isCheckedAllMong.value = _isSelectedMong.value;
    for (int i = 1; i < _isCheckedMong.length; i++) {
      if (_isHasVideoMong[i]) {
        _isCheckedMong[i] = _isSelectedMong.value;
      } else {
        _isCheckedMong[i] = false;
      }
    }
  }

  void applySingleSelectedLanguage(int readingId) {
    _isCheckedMong[readingId] = _isSelectedMong.value;
    if (!_isSelectedMong.value) _isCheckedAllMong.value = false;
  }

  void setHasVideoMong() async {
    _isHasVideoMong[0] = true;
    for (Reading reading
    in _topicService.topicReadings.topicReadings.readings) {
      // var response = await http.get(Uri.parse(reading.readingVideoMong));
      _isHasVideoMong[reading.id] = _isVideo(reading.readingVideoMong);
    }
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

  void onChangeTopicReadings(int index) async {
    _topicIndex.value = index;
    final readingRes =await _topicService.getReadingByTopic(index + 1);
    _readings.value = readingRes;
  }
}
