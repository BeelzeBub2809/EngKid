import 'package:EngKid/domain/question/question_repository.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';

class QuestionUsecases {
  final QuestionRepository _questionRepository;
  QuestionUsecases(this._questionRepository);

  Future<List<Question>> getQuestionByReadingId(Map<String, dynamic> body) async =>
      _questionRepository.getQuestionByReadingId(body);
}