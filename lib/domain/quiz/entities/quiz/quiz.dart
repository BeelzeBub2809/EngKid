import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/quiz/entities/question/question.dart';
import 'package:EngKid/domain/quiz/entities/quiz_reading/quiz_reading.dart';

part 'quiz.freezed.dart';
part 'quiz.g.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    @Default(QuizReading()) QuizReading reading,
    @Default([]) List<Question> questions,
    @Default("vi") String language,
  }) = _Quiz;
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}
