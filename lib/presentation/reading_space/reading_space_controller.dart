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
import 'package:EngKid/presentation/core/learning_path_service.dart';
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

import '../../widgets/dialog/toast_dialog.dart';

class ReadingSpaceController extends GetxController
    with WidgetsBindingObserver {
  ReadingSpaceController();

  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  final LearningPathService _learningPathService =
      Get.find<LearningPathService>();
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
      // final res = await _topicService.getTopicByGrade();
      // _topics.value = res;
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
        final pathId = selectedLearningPath.value!['id'] as int;
        await _learningPathService.fetchLearningPathCategories(pathId);

        // Get categories from service (now includes locked/unlocked info)
        learningPathCategories.value = _learningPathService.categories.toList();

        // Set selected category index from service (first unlocked category)
        selectedCategoryIndex.value =
            _learningPathService.selectedCategoryIndex.value;

        // Get items for selected category
        learningPathItems.value =
            _learningPathService.currentCategoryItems.toList();
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

      if (selectedLearningPath.value != null &&
          learningPathCategories.isNotEmpty &&
          selectedCategoryIndex.value < learningPathCategories.length) {
        final pathId = selectedLearningPath.value!['id'] as int;
        final categoryId =
            learningPathCategories[selectedCategoryIndex.value]['id'] as int;

        // Use the new merged API approach - items are already loaded
        await _learningPathService.fetchLearningPathItems(pathId, categoryId);
        learningPathItems.value =
            _learningPathService.currentCategoryItems.toList();
      }
    } catch (e) {
      learningPathItems.clear();
      if (kDebugMode) {
        print("Lỗi khi fetchLearningPathItems: $e");
      }
    }
  }

  void onChangeLearningPathCategory(int index) async {
    if (selectedLearningPath.value != null) {
      final pathId = selectedLearningPath.value!['id'] as int;

      // Check if category is unlocked before changing
      if (!isCategoryUnlocked(index)) {
        if (kDebugMode) {
          print("Cannot select locked category at index: $index");
        }
        // Play lock sound effect
        LibFunction.playAudioLocal(LocalAudio.lock);
        return; // Don't change to locked category
      }

      selectedCategoryIndex.value = index;
      await _learningPathService.changeCategory(pathId, index);
      learningPathItems.value =
          _learningPathService.currentCategoryItems.toList();
    }
  }

  // Helper method to get item type for debugging
  String getLearningPathItemType(Map<String, dynamic> item) {
    if (item['reading_id'] != null) {
      return 'Reading';
    } else if (item['game_id'] != null) {
      return 'Game';
    }
    return 'Unknown';
  }

  // Helper method to get prerequisite info for debugging
  String getLearningPathItemPrerequisiteInfo(Map<String, dynamic> item) {
    final prerequisiteReadingId = item['prerequisite_reading_id'];
    if (prerequisiteReadingId != null) {
      return 'Prerequisite Reading ID: $prerequisiteReadingId';
    }
    return 'No prerequisite';
  }

  void onPressLearningPathItem(Map<String, dynamic> item, int index) {
    // Check if item is unlocked
    if (!isLearningPathItemUnlocked(index)) {
      LibFunction.playAudioLocal(LocalAudio.lock);
      return;
    }

    // Handle learning path item press (reading or game)
    final isReading = item['reading_id'] != null;
    final isGame = item['game_id'] != null;

    if (isReading) {
      // Handle reading item - similar to onPressLesson but using readingId
      final readingId = item['reading_id'];
      if (kDebugMode) {
        print(
            "Pressed reading item: ${item['reading']?['title'] ?? 'Unknown'} (ID: $readingId)");
      }
      // Navigate to reading lesson with readingId
      onPressLearningPathReading(readingId: readingId, itemIndex: index);
    } else if (isGame) {
      // Handle game item - Navigate to Game Controller for pre-processing
      final gameId = item['game_id'];
      if (kDebugMode) {
        print("Pressed game item: ${item['name']} (ID: $gameId)");
      }

      // Navigate to game controller with gameId to handle pre-data processing
      _navigateToGameController(gameId, item);
    }
  }

  // Navigate directly to specific game based on gameId
  Future<void> _navigateToGameController(
      int gameId, Map<String, dynamic> gameItem) async {
    try {
      await LibFunction.effectConfirmPop();

      // Fetch game detail from API
      final gameDetailData = await fetchGameDetail(gameId);

      if (gameDetailData == null) {
        Get.snackbar('Lỗi', 'Không tìm thấy thông tin game');
        return;
      }

      final gameType = gameDetailData['type'] as String;

      // Create comprehensive game data from API response
      final gameData = {
        'game_id': gameDetailData['id'],
        'game_title': gameDetailData['name'] ?? 'Unknown Game',
        'game_type': gameType,
        'game_description': gameDetailData['description'] ?? '',
        'difficulty_level': 1, // Default difficulty
        'estimated_time': 300, // Default estimated time
        'max_score': 100, // Default max score
        'thumbnail': gameDetailData['image'] ?? '',
        'instructions': gameDetailData['description'] ?? '',
        'prerequisite_reading_id': gameDetailData['prerequisite_reading_id'],
        'is_active': gameDetailData['is_active'] == 1,
        'sequence_order': gameDetailData['sequence_order'] ?? 1,
      };

      if (kDebugMode) {
        print('Game detail loaded successfully:');
        print('ID: ${gameData['game_id']}');
        print('Type: ${gameData['game_type']}');
        print('Title: ${gameData['game_title']}');
        print('Description: ${gameData['game_description']}');
      }

      // Navigate directly to specific game based on game_type
      final result = await _navigateToSpecificGame(gameType, gameData);

      // Handle result if game completed and returned data
      if (result == true) {
        // Refresh learning path items nếu cần
        if (selectedLearningPath.value != null) {
          await fetchLearningPathItems();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi navigate to game: $e");
      }
      Get.snackbar('Lỗi', 'Không thể mở game. Vui lòng thử lại.');
    }
  }

  // Navigate to specific game based on game_type
  Future<dynamic> _navigateToSpecificGame(
      String gameType, Map<String, dynamic> gameData) async {
    switch (gameType) {
      case 'wordle':
        return await Get.toNamed(AppRoute.wordleGame, arguments: gameData);
      case 'puzzle':
        return await Get.toNamed(AppRoute.puzzleGame, arguments: gameData);
      case 'memory':
        return await Get.toNamed(AppRoute.memoryGame, arguments: gameData);
      case 'missing_word':
        return await Get.toNamed(AppRoute.missingWordGame, arguments: gameData);
      case 'image_puzzle':
        return await Get.toNamed(AppRoute.imagePuzzleGame, arguments: gameData);
      case 'four_pics_one_word':
        return await Get.toNamed(AppRoute.fourPicsOneWordGame,
            arguments: gameData);
      default:
        Get.snackbar('Lỗi', 'Loại game không được hỗ trợ: $gameType');
        return null;
    }
  }

  // Fetch reading detail from API using TopicService
  Future<Map<String, dynamic>?> fetchReadingDetail(int readingId) async {
    try {
      final result = await _topicService.getReadingDetail(readingId);
      if (result != null) {
        if (kDebugMode) {
          print('Reading detail fetched successfully via TopicService');
          print('Data: ${jsonEncode(result)}');
        }
        return result;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching reading detail via TopicService: $e');
      }
      return null;
    }
  }

  // Fetch game detail from API using TopicService
  Future<Map<String, dynamic>?> fetchGameDetail(int gameId) async {
    try {
      final result = await _topicService.getGameDetail(gameId);
      if (result != null) {
        if (kDebugMode) {
          print('Game detail fetched successfully via TopicService');
          print('Data: ${jsonEncode(result)}');
        }
        return result;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching game detail via TopicService: $e');
      }
      return null;
    }
  }

  Future<void> onPressLesson(
      {required Reading reading, required int index}) async {
    await LibFunction.effectConfirmPop();

    // Fetch detailed reading data from API
    final readingDetailData = await fetchReadingDetail(reading.id);

    if (readingDetailData != null) {
      // Update readingData with API response - only use available fields from Reading entity
      readingData = Reading(
        id: readingDetailData['id'],
        name: readingDetailData['title'] ?? reading.name,
        thumImg: readingDetailData['image'] ?? reading.thumImg,
        background: reading.background, // Keep existing background
        readingVideo: readingDetailData['file'] ?? reading.readingVideo,
        totalQuiz: reading.totalQuiz,
        totalCompleteQuiz: reading.totalCompleteQuiz,
        stars: reading.stars,
        maxAchievedStars: reading.maxAchievedStars,
        // Keep other existing fields from original reading
        achievedStars: reading.achievedStars,
        isActionGame: reading.isActionGame,
        isLocked: reading.isLocked,
        positionId: reading.positionId,
        readingVideoMong: reading.readingVideoMong,
        isCompleted: reading.isCompleted,
        isPassed: reading.isPassed,
        percentage: reading.percentage,
      );

      if (kDebugMode) {
        print('Reading detail loaded successfully:');
        print('Title: ${readingData.name}');
        print('Video URL: ${readingData.readingVideo}');
        print('Image URL: ${readingData.thumImg}');
        if (readingDetailData['description'] != null) {
          print('Description: ${readingDetailData['description']}');
        }
      }
    } else {
      // Fallback to existing reading data if API call fails
      readingData = reading;
      if (kDebugMode) {
        print('Using fallback reading data due to API failure');
      }
    }

    indexReading = index;

    // Fetch questions as usual
    var questions = await _topicService.getQuestionOfReading(readingData.id);

    // Create quiz with updated reading data
    var currentQuiz = Quiz(
      reading: QuizReading(
        name: readingData.name,
        id: readingData.id,
        thumImg: readingData.thumImg,
        background: readingData.background,
        video: readingData.readingVideo,
        videoMong: '',
        questionCount: readingData.totalQuiz == 0
            ? const Count()
            : Count(
                total: readingData.totalQuiz,
                complete: readingData.totalCompleteQuiz,
              ),
      ),
      questions: questions,
    );
    await startLearning(currentQuiz, index);
  }

  // Method for Learning Path Reading items - similar to onPressLesson but uses readingId
  Future<void> onPressLearningPathReading(
      {required int readingId, required int itemIndex}) async {
    await LibFunction.effectConfirmPop();

    // Fetch detailed reading data from API using readingId
    final readingDetailData = await fetchReadingDetail(readingId);

    if (readingDetailData != null) {
      // Create readingData from API response only
      readingData = Reading(
        id: readingDetailData['id'],
        name: readingDetailData['title'] ?? 'Unknown Reading',
        thumImg: readingDetailData['image'] ?? '',
        background: LocalImage.backgroundBlue, // Use default background
        readingVideo: readingDetailData['file'] ?? '',
        totalQuiz: 0, // Will be updated based on questions fetched
        totalCompleteQuiz: 0, // Will be updated based on progress
        stars: 5, // Default stars
        maxAchievedStars: 0.0, // Default achieved stars
        // Set default values for other required fields
        achievedStars: 0.0,
        isActionGame: false,
        isLocked: false,
        positionId: -1,
        readingVideoMong: '',
        isCompleted: 0,
        isPassed: 0,
        percentage: -1,
      );

      if (kDebugMode) {
        print('Learning Path Reading detail loaded successfully:');
        print('Title: ${readingData.name}');
        print('Video URL: ${readingData.readingVideo}');
        print('Image URL: ${readingData.thumImg}');
        if (readingDetailData['description'] != null) {
          print('Description: ${readingDetailData['description']}');
        }
      }
    } else {
      // Create minimal reading data if API call fails
      readingData = Reading(
        id: readingId,
        name: 'Reading $readingId',
        thumImg: '',
        background: LocalImage.backgroundBlue,
        readingVideo: '',
        totalQuiz: 0,
        totalCompleteQuiz: 0,
        stars: 5,
        maxAchievedStars: 0.0,
      );

      if (kDebugMode) {
        print(
            'Using fallback reading data for Learning Path item due to API failure');
      }
    }

    indexReading = itemIndex;

    // Fetch questions as usual
    var questions = await _topicService.getQuestionOfReading(readingData.id);

    // Update totalQuiz based on questions fetched
    readingData = readingData.copyWith(totalQuiz: questions.length);

    // Create quiz with reading data
    var currentQuiz = Quiz(
      reading: QuizReading(
        name: readingData.name,
        id: readingData.id,
        thumImg: readingData.thumImg,
        background: readingData.background,
        video: readingData.readingVideo,
        videoMong: '',
        questionCount: readingData.totalQuiz == 0
            ? const Count()
            : Count(
                total: readingData.totalQuiz,
                complete: readingData.totalCompleteQuiz,
              ),
      ),
      questions: questions,
    );
    await startLearningPathLearning(currentQuiz, itemIndex);
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

  Future<void> startLearningPathLearning(Quiz quiz, int itemIndex) async {
    final result = await Get.toNamed(
      AppRoute.lesson,
      arguments: [
        quiz, // current reading
        false, // is end - for learning path items, we don't use this logic
        readingData // Pass the reading data we created
      ],
    );
    if (result == true) {
      // Refresh learning path items instead of regular readings
      if (selectedLearningPath.value != null) {
        await fetchLearningPathItems();
      }
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
    if (progress['is_completed'] == true) {
      return LocalImage.lessonCompleted;
    }
    return LocalImage.lessonProgress;
  }

  // Check if category is unlocked
  bool isCategoryUnlocked(int categoryIndex) {
    if (learningPathCategories.isEmpty ||
        categoryIndex >= learningPathCategories.length) {
      return false;
    }

    // Category đầu tiên luôn luôn unlocked
    if (categoryIndex == 0) {
      return true;
    }

    // Kiểm tra field 'unlocked' từ API
    final category = learningPathCategories[categoryIndex];
    return category['unlocked'] == true;
  }

  // Check if learning path item is unlocked based on new logic
  bool isLearningPathItemUnlocked(int index) {
    if (learningPathItems.isEmpty || index >= learningPathItems.length)
      return false;

    final currentItem = learningPathItems[index];

    // Check if item is a reading or game
    final isReading = currentItem['reading_id'] != null;
    final isGame = currentItem['game_id'] != null;

    if (isReading) {
      // For reading items: follow old logic - depends on previous reading completion
      if (index == 0) {
        return true; // First reading is always unlocked
      }

      // Find the previous reading item (skip games)
      for (int i = index - 1; i >= 0; i--) {
        final previousItem = learningPathItems[i];
        if (previousItem['reading_id'] != null) {
          final progress = previousItem['student_progress'];
          return progress['is_completed'] == true;
        }
      }
      return true; // If no previous reading found, unlock
    } else if (isGame) {
      // For game items: depends on prerequisite_reading_id
      final prerequisiteReadingId = currentItem['prerequisite_reading_id'];

      if (prerequisiteReadingId == null) {
        return true; // No prerequisite, unlock the game
      }

      // Find the reading with prerequisite_reading_id and check if it's unlocked
      for (int i = 0; i < learningPathItems.length; i++) {
        final item = learningPathItems[i];
        if (item['reading_id'] == prerequisiteReadingId) {
          // Check if this reading is unlocked first
          if (isLearningPathItemUnlocked(i)) {
            final progress = item['student_progress'];
            return progress['is_completed'] == true;
          }
          return false;
        }
      }
      return false; // Prerequisite reading not found, lock the game
    }

    return false; // Default to locked
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
            // int loginRecordId = _preferencesManager.getInt(
            //   KeySharedPreferences.loginRecord +
            //       _userService.currentUser.id.toString(),
            // )!;
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
