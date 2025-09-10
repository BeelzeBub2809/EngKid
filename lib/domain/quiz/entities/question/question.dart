// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/quiz/entities/connection/connection.dart';
import 'package:EngKid/domain/quiz/entities/option/option.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const factory Question({
    @Default([]) List<Option> options,
    @Default([]) List<Connection> connection,
    @JsonKey(name: 'question_id') @Default(-1) int questionId,
    @Default("") String question,
    @Default("") String background,
    @JsonKey(name: 'is_action_game') @Default(false) bool isActionGame,
    @JsonKey(name: 'is_result_calculatable')
    @Default(false)
    bool isResultCalculatable,
    @Default("") String type,
    @JsonKey(name: 'type_code') @Default("") String typeCode,
    @JsonKey(name: 'currect_connection') @Default("") String currectConnection,
    @Default('') String video,
    @JsonKey(name: 'achieved_mark') @Default("0") dynamic achievedMark,
    @JsonKey(name: 'attempt') @Default(0) int attempt,
    @JsonKey(name: 'level')@Default("1") String level,
    @JsonKey(name: 'isLearned')
    @Default(false)
    bool isLearned, // true: đã học - false: chưa học
    @Default(0) int mark,
    @JsonKey(name: 'video_mong') @Default("") String video_mong,
    @JsonKey(name: 'audio_file') @Default("") String audio,
    @JsonKey(name: 'child_question') @Default([]) List<Question> childQuestion,
    // Add image fields
    @JsonKey(name: 'image_1') @Default("") String image1,
    @JsonKey(name: 'image_2') @Default("") String image2,
    @JsonKey(name: 'image_3') @Default("") String image3,
    @JsonKey(name: 'image_4') @Default("") String image4,
    @JsonKey(name: 'image_5') @Default("") String image5,
    @JsonKey(name: 'image_6') @Default("") String image6,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
