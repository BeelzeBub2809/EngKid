import 'package:EngKid/data/core/remote/api/learning_path_api/learning_path_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/learning_path/learning_path_repository.dart';

class LearningPathRepositoryImp implements LearningPathRepository {
  final LearningPathApi learningPathApi;

  LearningPathRepositoryImp({required this.learningPathApi});

  @override
  Future<List<Map<String, dynamic>>> getListLearningPaths() async {
    try {
      final ApiResponseObject response =
          await learningPathApi.getListLearningPaths();
      if (response.result) {
        final data = response.data as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['record'] ?? []);
      } else {
        throw Exception('Failed to get learning paths list');
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<Map<String, dynamic>> getLearningPathItems(
      int pathId, int studentId) async {
    try {
      final ApiResponseObject response =
          await learningPathApi.getLearningPathItems(pathId, studentId);
      if (response.result) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get learning path items');
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
