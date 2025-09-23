import 'package:EngKid/domain/learning_path/learning_path_repository.dart';

class LearningPathUseCases {
  final LearningPathRepository _learningPathRepository;

  LearningPathUseCases(this._learningPathRepository);

  Future<List<Map<String, dynamic>>> getListLearningPaths() =>
      _learningPathRepository.getListLearningPaths();

  Future<Map<String, dynamic>> getLearningPathItems(
          int pathId, int studentId) =>
      _learningPathRepository.getLearningPathItems(pathId, studentId);
}
