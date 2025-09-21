abstract class LearningPathRepository {
  Future<Map<String, dynamic>> getLearningPathCategories(int pathId);
  Future<List<Map<String, dynamic>>> getLearningPathItems(
      int pathId, int categoryId, int studentId);
}
