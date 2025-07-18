import 'package:EngKid/domain/quiz/entities/entites.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestionByReadingId(Map<String, dynamic> body);
}