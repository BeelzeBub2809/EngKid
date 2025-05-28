import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/data/core/local/share_preferences_manager.dart';
import 'package:EzLish/di/injection.dart';
import 'package:EzLish/domain/core/app_usecases.dart';
import 'package:EzLish/domain/core/entities/lesson/entities/entities.dart';
import 'package:EzLish/domain/core/entities/lesson/lesson.dart';
import 'package:EzLish/domain/core/entities/submit_answer/submit_answer.dart';
import 'package:EzLish/domain/grade/entities/entities.dart';
import 'package:EzLish/domain/quiz/entities/entites.dart';
import 'package:EzLish/domain/topic/entities/entites.dart';
import 'package:EzLish/presentation/core/network_service.dart';
import 'package:EzLish/utils/key_shared_preferences.dart';
import 'package:EzLish/utils/lib_function.dart';

import 'user_service.dart';

class TopicService extends GetxService {
  final AppUseCases appUseCases;
  TopicService({required this.appUseCases});

  final UserService _userService = Get.find<UserService>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final RxInt _topicIndex = 0.obs;
  final RxBool _isGetTopicReadings = false.obs;
  final RxList<Grade> _grades = RxList<Grade>.empty(growable: true);
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

  // Grades ==============================================
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
