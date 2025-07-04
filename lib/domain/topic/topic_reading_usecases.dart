import 'package:EngKid/domain/topic/entities/entites.dart';
import 'package:EngKid/domain/topic/topic_reading_repository.dart';

class TopicReadingUsecases {
  final TopicReadingRepository _topicReadingRepository;
  TopicReadingUsecases(this._topicReadingRepository);

  Future<List<Topic>> getAll(Map<String, dynamic> body) async =>
      _topicReadingRepository.getAll(body);
  Future<List<Topic>> getByGrade(int gradeId) async =>
      _topicReadingRepository.getByGrade(gradeId);
}