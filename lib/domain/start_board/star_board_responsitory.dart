import 'package:EngKid/domain/start_board/entities/learning_path_stars.dart';

abstract class StarBoardRepository {
  Future<dynamic> getStarsHistory(
      int studentId, String startDate, String endDate);

  Future<LearningPathStars> getLearningPathStars(int studentId, int learningPathId);
}
