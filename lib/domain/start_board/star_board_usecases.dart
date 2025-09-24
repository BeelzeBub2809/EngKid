import 'star_board_responsitory.dart';
import 'entities/learning_path_stars.dart';

class StarBoardUseCases {
  final StarBoardRepository _starBoardRepository;
  StarBoardUseCases(this._starBoardRepository);

  Future<dynamic> getStarsHistory({
    required int studentId,
    required String startDate,
    required String endDate,
  }) =>
      _starBoardRepository.getStarsHistory(studentId, startDate, endDate);

  Future<LearningPathStars> getLearningPathStars({
    required int studentId,
    required int learningPathId,
  }) =>
      _starBoardRepository.getLearningPathStars(studentId, learningPathId);
}
