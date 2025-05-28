import 'package:EngKid/domain/survey/entities/entities.dart';

abstract class SurveyRepository {
  Future<SurveyContent> getSurveyContent(int studentId);
  Future<dynamic> getQuizsSurvey(int studentId);
  Future<dynamic> submitAnswersSurvey();
}
