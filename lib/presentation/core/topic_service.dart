import 'dart:convert';

import 'package:EngKid/data/reading/reading_request/reading_by_topic_request.dart';
import 'package:EngKid/data/topic_reading/topic_reading_request/topic_reading_request.dart';
import 'package:EngKid/domain/question/question_usecases.dart';
import 'package:EngKid/domain/reading/reading_usecases.dart';
import 'package:EngKid/domain/topic/topic_reading_usecases.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/app_usecases.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/core/entities/lesson/lesson.dart';
import 'package:EngKid/domain/core/entities/submit_answer/submit_answer.dart';
import 'package:EngKid/domain/grade/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

import 'user_service.dart';

class TopicService extends GetxService {
  final AppUseCases appUseCases;
  TopicService({required this.appUseCases});

  final UserService _userService = Get.find<UserService>();
  final TopicReadingUsecases _topicReadingUsecases = Get.find<TopicReadingUsecases>();
  final ReadingUsecases _readingUsecases = Get.find<ReadingUsecases>();
  final QuestionUsecases _questionUsecases = Get.find<QuestionUsecases>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final RxInt _topicIndex = 0.obs;
  final RxBool _isGetTopicReadings = false.obs;
  final RxList<Grade> _grades = RxList<Grade>.empty(growable: true);
  final RxList<Topic> _topicReading = RxList<Topic>.empty(growable: true);
  final RxList<Reading> _readings = RxList<Reading>.empty(growable: true);
  final RxList<Question> _questionList = RxList<Question>.empty(growable: true);
  final Rx<ProgressGrade> _progressGrade = const ProgressGrade().obs;
  final Rx<Lesson> _topicReadings = const Lesson().obs;
  final RxString _topicBg = "".obs;
  List<Topic> topicList = List<Topic>.empty(growable: true);
  final RxList<Reading> downloadAllReadingList =
      RxList<Reading>.empty(growable: true);
  late Grade _currentGrade = const Grade();
  late Quiz currentQuiz = const Quiz();
  late String readingName = "";
  late bool isCaculator = true;

  int get topicIndex => _topicIndex.value;
  bool get isGetTopicReadings => _isGetTopicReadings.value;
  Grade get currentGrade => _currentGrade;
  String get topicBg => _topicBg.value;

  set currentGrade(Grade value) {
    _currentGrade = value;
    saveGradeToStorage();
  }

  List<Grade> get grades => _grades;
  ProgressGrade get progressGrade => _progressGrade.value;
  Lesson get topicReadings => _topicReadings.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('Init Topic Service ');
  }

  // Other api ==============================================

  Future<List<Topic>> getAllTopic() async {
    try {
      final request = TopicReadingRequest(
        pageNumb: 1,
        pageSize: 10,
        searchTerm: '',
        sort: null,
      );
      final result = await _topicReadingUsecases.getAll(request.toJson());
      _topicReading.assignAll(result);
      return _topicReading;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Question>> getQuestionOfReading(int readingId) async {
    try {
      final Map<String, dynamic> request = {
        "readingId": readingId
      };
      final result = await _questionUsecases.getQuestionByReadingId(request);
      print('📦 Result: ${jsonEncode(result)}');
      _questionList.assignAll(result);
      return _questionList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitReadingResult(int kid_student_id, int kid_reading_id, int score, int is_completed, double duration) async {
    try {
      final Map<String, dynamic> request = {
        "kid_student_id": kid_student_id,
        "kid_reading_id": kid_reading_id,
        "score": score,
        "is_completed": is_completed,
        "duration": duration
      };
      await _readingUsecases.submitReadingResult(request);
    } catch (e){
      rethrow;
    }
  }

  Future<List<Reading>> getReadingByTopic(int cateId) async {
    try {
      final request = ReadingByTopicRequest(
        categoryId: cateId,
        studentId: 44,
      );

      final result = await _readingUsecases.getByCateAndStudent(request.toJson());
      _readings.assignAll(result);
      return _readings;
    } catch (e, stackTrace) {
      debugPrint('[ReadingService] Error: $e');
      debugPrint('[ReadingService] StackTrace: $stackTrace');
      rethrow;
    }
  }
  // Grades ==============================================
  Future<List<Topic>> getTopicByGrade() async {
    try {
      final result = await _topicReadingUsecases.getByGrade(currentGrade.id);
      _topicReading.assignAll(result);
      return _topicReading;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> getLibrary() async {
    try {
      const imageUrl = "assets/images";
      //custom for teacher

      //init 5 grades
      List<Grade> grades = [];

      for(int index = 0; index < 5; index++) {
        grades.add(
          Grade(
            id: index + 1,
            name: "grade_${index + 1}".tr,
            image: "$imageUrl/grade${index + 1}.png",
            isOpen: true,
          ),
        );
      }
      // List.generate(
      //     5,
      //         (index) {
      //       grades.add(
      //         Grade(
      //           id: index+1,
      //           name: "Grade ${index + 1}",
      //           image: "$imageUrl/grade${index + 1}.png",
      //           isOpen: _userService.userLogin.roleId == "2",
      //         ),
      //       );
      //     });
      //
      assignGrades(grades);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getGradesFromStorage({bool isAwait = false}) async {
    final String? grades = _preferencesManager.getString(
      KeySharedPreferences.grades,
    );

    if (grades != null) {
      final decodeGrades = List<Map<String, dynamic>>.from(jsonDecode(grades));

      _grades.assignAll(
        decodeGrades.map<Grade>((json) => Grade.fromJson(json)).toList(),
      );
      if (_networkService.networkConnection.value) {
        if (isAwait == true) {
          await getLibrary();
        } else {
          getLibrary();
        }
      }
      return true;
    } else {
      if (_networkService.networkConnection.value) {
        if (isAwait == true) {
          await getLibrary();
        } else {
          getLibrary();
        }
      }else{
        LibFunction.toast('require_network_to_get_grades');
      }
      return false;
    }
  }

  Future<void> assignGrades(List<Grade> grades) async {
    _grades.assignAll(grades);
    await saveGradesToStorage();
  }

  Future<void> saveGradesToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.grades,
      value: jsonEncode(
        _grades.map((e) => e.toJson()).toList(),
      ),
    );
  }

  // Current Grade ==============================================
  bool getGradeFromStorage() {
    final String? grade = _preferencesManager.getString(
      KeySharedPreferences.grade,
    );
    if (grade != null) {
      final decodeGrade = Grade.fromJson(jsonDecode(grade));
      _currentGrade = decodeGrade;
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveGradeToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.grade,
      value: jsonEncode(_currentGrade.toJson()),
    );
  }

  // Progress ==============================================

  // Lesson ==============================================
}
