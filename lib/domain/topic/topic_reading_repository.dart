import 'package:EngKid/domain/topic/entities/entites.dart';

abstract class TopicReadingRepository {
  Future<List<Topic>> getAll(Map<String, dynamic> body);
  Future<List<Topic>> getByGrade(int gradeId);
}
