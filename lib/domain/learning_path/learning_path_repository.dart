abstract class LearningPathRepository {
  Future<List<Map<String, dynamic>>> getListLearningPaths();
  Future<Map<String, dynamic>> getLearningPathItems(int pathId, int studentId);
}
