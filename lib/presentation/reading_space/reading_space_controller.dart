import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:EngKid/widgets/dialog/dialog_downloadwarning.dart';
import 'package:EngKid/widgets/dialog/dialog_select_download_language.dart';
import 'package:EngKid/widgets/dialog/dialog_warning_time.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

import '../../widgets/dialog/toast_dialog.dart';

class ReadingSpaceController extends GetxController
    with WidgetsBindingObserver {
  ReadingSpaceController();

  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();

  late VideoPlayerController? _videoController;

  // Learning Path Variables
  final Rxn<Map<String, dynamic>> selectedLearningPath =
      Rxn<Map<String, dynamic>>();
  final RxList<Map<String, dynamic>> learningPathItems =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> learningPathCategories =
      <Map<String, dynamic>>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;

  // Mock Learning Path Data with Categories
  final Map<String, dynamic> mockLearningPathWithCategories = {
    "id": 1,
    "title": "English for Beginners",
    "description": "Lộ trình học tiếng Anh cơ bản cho trẻ em",
    "categories": [
      {
        "id": 1,
        "title": "Animals",
        "description": "Học về các loài động vật",
        "image": "https://minio-url/categories/animals.jpg",
        "items": [
          {
            "id": 1,
            "reading_id": 15,
            "game_id": null,
            "sequence_order": 1,
            "reading": {
              "id": 15,
              "title": "The Little Cat",
              "description": "Câu chuyện về chú mèo nhỏ đáng yêu",
              "image": "https://minio-url/kid_reading/cat_story_001.jpg",
              "file": "https://minio-url/kid_reading/cat_story_001.mp4",
              "difficulty_level": 1
            },
            "game": null,
            "student_progress": {"is_completed": 1, "score": 85, "star": 4.5}
          },
          {
            "id": 2,
            "reading_id": null,
            "game_id": 1,
            "sequence_order": 2,
            "reading": null,
            "game": {
              "id": 1,
              "name": "Animal Matching Game",
              "description": "Ghép các con vật với tên của chúng",
              "type": 1
            },
            "student_progress": {"is_completed": 1, "score": null, "star": 5.0}
          },
          {
            "id": 3,
            "reading_id": 16,
            "game_id": null,
            "sequence_order": 3,
            "reading": {
              "id": 16,
              "title": "The Big Dog",
              "description": "Chú chó lớn thân thiện",
              "image": "https://minio-url/kid_reading/dog_story_001.jpg",
              "file": "https://minio-url/kid_reading/dog_story_001.mp4",
              "difficulty_level": 1
            },
            "game": null,
            "student_progress": {"is_completed": 0, "score": null, "star": null}
          }
        ]
      },
      {
        "id": 2,
        "title": "Colors",
        "description": "Học về các màu sắc",
        "image": "https://minio-url/categories/colors.jpg",
        "items": [
          {
            "id": 4,
            "reading_id": 17,
            "game_id": null,
            "sequence_order": 1,
            "reading": {
              "id": 17,
              "title": "Rainbow Colors",
              "description": "Câu chuyện về cầu vồng nhiều màu",
              "image": "https://minio-url/kid_reading/rainbow_001.jpg",
              "file": "https://minio-url/kid_reading/rainbow_001.mp4",
              "difficulty_level": 1
            },
            "game": null,
            "student_progress": {"is_completed": 1, "score": 92, "star": 5.0}
          },
          {
            "id": 5,
            "reading_id": null,
            "game_id": 2,
            "sequence_order": 2,
            "reading": null,
            "game": {
              "id": 2,
              "name": "Color Puzzle",
              "description": "Xếp hình theo màu sắc",
              "type": 2
            },
            "student_progress": {"is_completed": 0, "score": null, "star": null}
          }
        ]
      },
      {
        "id": 3,
        "title": "Numbers",
        "description": "Học đếm số từ 1 đến 10",
        "image": "https://minio-url/categories/numbers.jpg",
        "items": [
          {
            "id": 6,
            "reading_id": 18,
            "game_id": null,
            "sequence_order": 1,
            "reading": {
              "id": 18,
              "title": "Counting to Ten",
              "description": "Học đếm từ 1 đến 10",
              "image": "https://minio-url/kid_reading/numbers_001.jpg",
              "file": "https://minio-url/kid_reading/numbers_001.mp4",
              "difficulty_level": 1
            },
            "game": null,
            "student_progress": {"is_completed": 0, "score": null, "star": null}
          },
          {
            "id": 7,
            "reading_id": null,
            "game_id": 3,
            "sequence_order": 2,
            "reading": null,
            "game": {
              "id": 3,
              "name": "Number Quiz",
              "description": "Trắc nghiệm về số",
              "type": 3
            },
            "student_progress": {"is_completed": 0, "score": null, "star": null}
          }
        ]
      },
      {
        "id": 4,
        "title": "Family",
        "description": "Học về các thành viên trong gia đình",
        "image": "https://minio-url/categories/family.jpg",
        "items": [
          {
            "id": 8,
            "reading_id": 19,
            "game_id": null,
            "sequence_order": 1,
            "reading": {
              "id": 19,
              "title": "My Family",
              "description": "Câu chuyện về gia đình tôi",
              "image": "https://minio-url/kid_reading/family_001.jpg",
              "file": "https://minio-url/kid_reading/family_001.mp4",
              "difficulty_level": 1
            },
            "game": null,
            "student_progress": {"is_completed": 1, "score": 78, "star": 3.5}
          }
        ]
      }
    ]
  };

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
  final RxBool _isLoading = true.obs;
  final RxInt _topicIndex = 0.obs;

  final RxBool _isCheckAll = false.obs;

  bool get isDownload => _isDownload.value;

  bool get isLoading => _isLoading.value;

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
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic>) {
      selectedLearningPath.value = arguments;
    } else {
      selectedLearningPath.value = null;
    }
    _readingSequence.value =
        _userService.readingSequenceSetting.readingSequenceSetting;
    WidgetsBinding.instance.addObserver(this);
    if (selectedLearningPath.value != null) {
      await fetchLearningPathCategories();
    } else {
      await fetchData();
    }
  }

  @override
  void onReady() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      _isLoading.value = true;
      _readings.clear();
      _topics.clear();
      final res = await _topicService.getTopicByGrade();
      _topics.value = res;
      _topicIndex.value = 0;

      if (_topics.isNotEmpty) {
        final readingRes = await _topicService
            .getReadingByTopic(_topics[_topicIndex.value].id);
        _readings.value = readingRes;
      }
    } catch (e) {
      _readings.clear();
      if (kDebugMode) {
        print("Lỗi khi fetchData: $e");
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Learning Path Methods
  Future<void> fetchLearningPathCategories() async {
    try {
      _isLoading.value = true;
      learningPathCategories.clear();
      learningPathItems.clear();

      if (selectedLearningPath.value != null) {
        final categories = mockLearningPathWithCategories['categories'] as List;
        learningPathCategories.value =
            List<Map<String, dynamic>>.from(categories);

        if (learningPathCategories.isNotEmpty) {
          selectedCategoryIndex.value = 0;
          await fetchLearningPathItems();
        }
      }
    } catch (e) {
      learningPathCategories.clear();
      learningPathItems.clear();
      if (kDebugMode) {
        print("Lỗi khi fetchLearningPathCategories: $e");
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchLearningPathItems() async {
    try {
      learningPathItems.clear();

      if (learningPathCategories.isNotEmpty &&
          selectedCategoryIndex.value < learningPathCategories.length) {
        final selectedCategory =
            learningPathCategories[selectedCategoryIndex.value];
        final items = selectedCategory['items'] as List;
        learningPathItems.value = List<Map<String, dynamic>>.from(items);
      }
    } catch (e) {
      learningPathItems.clear();
      if (kDebugMode) {
        print("Lỗi khi fetchLearningPathItems: $e");
      }
    }
  }

  void onChangeLearningPathCategory(int index) {
    selectedCategoryIndex.value = index;
    fetchLearningPathItems();
  }

  void onPressLearningPathItem(Map<String, dynamic> item, int index) {
    // Check if item is unlocked
    if (!isLearningPathItemUnlocked(index)) {
      LibFunction.playAudioLocal(LocalAudio.lock);
      return;
    }

    // Handle learning path item press (reading or game)
    final isReading = item['reading'] != null;

    if (isReading) {
      // Handle reading item
      if (kDebugMode) {
        print("Pressed reading item: ${item['reading']['title']}");
      }
      // Add navigation to reading screen here
    } else {
      // Handle game item
      if (kDebugMode) {
        print("Pressed game item: ${item['game']['name']}");
      }
      // Add navigation to game screen here
    }
  }

  Future<void> onPressLesson(
      {required Reading reading, required int index}) async {
    await LibFunction.effectConfirmPop();
    readingData = reading;
    indexReading = index;
    var questions = await _topicService.getQuestionOfReading(readingData.id);
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
      questions: questions,
    );
    await startLearning(currentQuiz, index);
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

  Future<void> startLearning(Quiz quiz, int index) async {
    final result = await Get.toNamed(
      AppRoute.lesson,
      arguments: [
        quiz, // current reading
        readings.length - 1 == index, // is end
        readings[index]
      ],
    );
    if (result == true) {
      await fetchData();
    }
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

  String getLearningPathItemStatus(Map<String, dynamic> item) {
    final progress = item['student_progress'];
    if (progress['is_completed'] == 1) {
      return LocalImage.lessonCompleted;
    }
    return LocalImage.lessonProgress;
  }

  // Check if learning path item is unlocked based on completion logic
  bool isLearningPathItemUnlocked(int index) {
    if (learningPathItems.isEmpty) return false;

    // First item is always unlocked if not completed
    if (index == 0) {
      return true;
    }

    // For other items, check if all previous items are completed
    for (int i = 0; i < index; i++) {
      final previousItem = learningPathItems[i];
      final progress = previousItem['student_progress'];
      if (progress['is_completed'] != 1) {
        return false; // Previous item not completed, so this item is locked
      }
    }

    // Current item should be unlocked if all previous are completed
    final currentItem = learningPathItems[index];
    final progress = currentItem['student_progress'];
    return progress['is_completed'] == 1 || // Already completed
        (index > 0 &&
            learningPathItems[index - 1]['student_progress']['is_completed'] ==
                1); // Previous completed, this unlocked
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
            "${_topicService.currentGrade.id}_${LibFunction.startOfDateNow().microsecondsSinceEpoch}_timeLimit",
        value: _remainingTime);
  }

  int getTimeLimitFromStorage() {
    try {
      final int? timeLimit = _preferencesManager.getInt(
          "${_topicService.currentGrade.id}_${LibFunction.startOfDateNow().microsecondsSinceEpoch}_timeLimit");
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

  @override
  void onClose() {
    // save timer use app to local
    saveTimeLimitToStorage();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
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

  void handleChangeLanguageDownload(String languageCode) {
    switch (languageCode) {
      case "mo":
        _isSelectedMong.value = !_isSelectedMong.value;
        break;
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
    try {
      _isLoading.value = true;
      _topicIndex.value = index;
      _readings.clear();

      final readingRes =
          await _topicService.getReadingByTopic(_topics[topicIndex].id);
      _readings.value = readingRes;
    } catch (e) {
      _readings.clear();
      if (kDebugMode) {
        print("Lỗi khi onChangeTopicReadings: $e");
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
