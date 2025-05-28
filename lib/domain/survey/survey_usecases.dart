import 'package:EzLish/domain/survey/entities/entities.dart';

import 'survey_repository.dart';

class SurveyUsecases {
  final SurveyRepository _surveyRepository;
  SurveyUsecases(this._surveyRepository);

  Future<SurveyContent> getSurveyContent(int studentId) =>
      _surveyRepository.getSurveyContent(studentId);

  Future<dynamic> getQuizsSurvey(int studentId) =>
      _surveyRepository.getQuizsSurvey(studentId);

  Future<dynamic> submitAnswersSurvey() =>
      _surveyRepository.submitAnswersSurvey();
}
