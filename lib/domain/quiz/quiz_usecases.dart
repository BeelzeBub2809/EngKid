import 'dart:convert';
import 'package:get/get.dart' hide MultipartFile;
import 'package:intl/intl.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:dio/dio.dart';

class QuizUseCases {
  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  late double duration = 0;
  late Reading reading;
  late int starRecordId = -1;

  Future<void> submitQuestion(
      {required int readingId,
      required int questionId,
      required bool isCorrect,
      required int attempt,
      required Map<String, dynamic> data,
      required double duration,
      bool isCompleted = false}) async {
    if (!_topicService.isCaculator) return;
    final int mark = isCorrect ? 1 : 0;
    // final double percent = _userService.getAchievedStar(attempt -
    //     1); // vì đã tăng một lần cố gắng nên phải trừ đi một để lấy sao cho lần cố gắng hiện tại
    final double starEachQuiz = reading.stars / reading.totalQuiz;
    final double star = starEachQuiz; // star

    final Question? question = _topicService.currentQuiz.questions
        .firstWhereOrNull((element) => element.questionId == questionId);
    if (question != null) {
      if (mark == 1 && question.mark == 0) {
        // _topicService.updateStarCount(
        //     star); // Nếu câu hiện tại hoàn thành đúng thì cộng sao
      } else if (mark == 0 && question.mark == 1) {
        // _topicService.updateStarCount(
        //     -star); // Nếu câu hiện tại hoàn thành đúng thì cộng sao
      }
    }

    // _topicService.updateQuestion(questionId: questionId, mark: mark);
    final double totalStar = caculateStar();

    // _topicService.updateStarReading(
    //   // update in reading
    //   readingId: readingId,
    //   achievedStars: totalStar,
    // );

    final String date =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    saveToStarHistory(
      date: date,
      star: star,
      readingId: readingId,
      readingName: _topicService.readingName,
    );

    data["star[$questionId]"] = star;
    data["questionId"] = questionId;
    data["mark[$questionId]"] = mark;
    if (_networkService.networkConnection.value) {
      try {
        final Map<String, dynamic> map = {};
        map['kid_student_id'] = _userService.currentUser.id;
        map['reading_id'] = readingId;
        map["mark[$questionId]"] = mark;
        if (data["isFile"] == true) {
          final String pathFile = await LibFunction.getFileFromCache(
              data["question_answer[$questionId]"].toString());
          if (pathFile != "") {
            map["question_answer[$questionId]"] = MultipartFile.fromFileSync(
              pathFile,
              filename: data["question_answer[$questionId]"].toString(),
            );
          }
        } else {
          map["question_answer[$questionId]"] =
              data["question_answer[$questionId]"];
        }
        // await _topicService.submitAnswers(map);
        if (data["isFile"] == true) {
          LibFunction.removeFileCache(
              data["question_answer[$questionId]"].toString());
        }
        //   int returnId = await _topicService.updateStars(
        //   studentId: _userService.currentUser.id,
        //   readingId: readingId,
        //   star: totalStar > 5 ? 5 : totalStar,
        //   date: date,
        //   duration: duration,
        //   isCompleted: isCompleted,
        //   starRecordId: starRecordId,
        // );

        // starRecordId = returnId;
      } catch (e) {
        //
      }
    } else {
      saveQuestionToStorage(
        readingId: readingId,
        questionId: questionId,
        data: data,
      );
    }
  }

  void saveQuestionToStorage({
    required int readingId,
    required int questionId,
    required Map<String, dynamic> data,
  }) async {
    final String keyReading =
        "reading_${_userService.currentUser.id}_${readingId}_${LibFunction.startOfDateNow().millisecondsSinceEpoch}";
    final String? questionAnswer = _preferencesManager.getString(
      keyReading,
    );
    if (questionAnswer != null) {
      // Cập nhật
      final decodeQuestionAnswer =
          List<Map<String, dynamic>>.from(jsonDecode(questionAnswer));
      for (final Map<String, dynamic> element in decodeQuestionAnswer) {
        if (element.containsKey("question_answer[$questionId]")) {
          // remove old key
          element.assignAll({});
        }
      }
      decodeQuestionAnswer.add(data);
      await _preferencesManager.putString(
        key: keyReading,
        value: jsonEncode(
          decodeQuestionAnswer
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
        key: keyReading,
        value: jsonEncode(newData),
      );
    }
  }

  void saveToReportTime({
    required String date,
    required String duration,
    required int readingTopic,
  }) {
    final List<History> dataYear = LibFunction.getHistoryFromStorage(
      KeySharedPreferences.timeYear,
    );
    final index = dataYear.indexWhere((element) => element.date == date);
    if (index != -1) {
      dataYear.removeAt(index);
    }
    dataYear.add(
      History(
        date: date,
        duration: duration,
        readingTopic: readingTopic.toString(),
      ),
    );
    LibFunction.saveHistoryStorage(KeySharedPreferences.timeYear, dataYear);
  }

  void saveToStarHistory({
    required String date,
    required double star,
    required String readingName,
    required int readingId,
  }) {
    final List<History> dataStarOfTwoYear = LibFunction.getHistoryFromStorage(
      KeySharedPreferences.starOfTwoYear,
    );
    dataStarOfTwoYear.add(
      History(
        date: date,
        star: star,
        readingId: readingId,
        readingTopic: readingName,
      ),
    );
    LibFunction.saveHistoryStorage(
        KeySharedPreferences.starOfTwoYear, dataStarOfTwoYear);
  }

  double caculateStar() {
    late double totalStar = 0; // stars
    final double starEachQuiz = reading.stars / reading.totalQuiz;

    for (final Question element in _topicService.currentQuiz.questions) {
      if (element.mark == 1) {
        totalStar += starEachQuiz;
      }
    }
    return totalStar;
  }
}
