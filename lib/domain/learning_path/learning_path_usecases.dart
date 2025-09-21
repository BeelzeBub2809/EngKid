import 'package:EngKid/domain/learning_path/learning_path_repository.dart';

class LearningPathUseCases {
  final LearningPathRepository _learningPathRepository;

  LearningPathUseCases(this._learningPathRepository);

  Future<Map<String, dynamic>> getLearningPathCategories(int pathId) =>
      _learningPathRepository.getLearningPathCategories(pathId);

  Future<List<Map<String, dynamic>>> getLearningPathItems(
          int pathId, int categoryId, int studentId) =>
      _learningPathRepository.getLearningPathItems(
          pathId, categoryId, studentId);
}
