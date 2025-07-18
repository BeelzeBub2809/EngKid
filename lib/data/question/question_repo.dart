import 'package:EngKid/data/core/remote/api/question_api/question_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/question/question_repository.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:dio/dio.dart';

class QuestionRepositoryImp implements QuestionRepository {
  final QuestionApi questionApi;
  QuestionRepositoryImp({required this.questionApi});

  @override
  Future<List<Question>> getQuestionByReadingId(Map<String, dynamic> body) async {
    try {

      final ApiResponseObject response = await questionApi.getQuestionByReadingId(body);
      final data = response.data;
      if (response.result && data != null && data['records'] != null) {
        final List<dynamic> records = data['records'];
        final s = records.map((e) => Question.fromJson(e)).toList();
        return s;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[Repository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[Repository] Unknown exception: $e');
        print('[Repository] StackTrace: $stackTrace');
      }
      return [];
    }
  }
}