import 'package:EngKid/data/core/remote/api/student_reading_api/student_reading_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/domain/start_board/entities/learning_path_stars.dart';
import 'package:EngKid/domain/start_board/star_board_responsitory.dart';

import '../core/remote/api/reading_api/reading_api.dart';

class StarBoardRepoImp implements StarBoardRepository {
  final StudentReadingApi studentReadingApi;
  StarBoardRepoImp({required this.studentReadingApi});

  @override
  Future<List<History>> getStarsHistory(int studentId, String startDate, String endDate) async {

    Map<String, dynamic> request = {
      'kid_student_id': studentId,
      'start_date': startDate,
      'end_date': endDate
    };

    final ApiResponseObject response = await studentReadingApi.getReadingHistory(request);

    final List<dynamic> data = response.data;

    if (data != null) {
      final List<History> histories = data.map((e) => History.fromJson(e)).toList() as List<History>;
      print(histories);
      return histories;
    } else {
      return [];
    }
  }

  @override
  Future<LearningPathStars> getLearningPathStars(int studentId, int learningPathId) async {
    try {
      final ApiResponseObject response = await studentReadingApi.getLearningPathStars(
        studentId,
        learningPathId,
      );

      if (response.data != null) {
        return LearningPathStars.fromJson(response.data);
      } else {
        throw Exception('No data returned from API');
      }
    } catch (e) {
      rethrow;
    }
  }
}