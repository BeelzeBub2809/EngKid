// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'submit_answer.freezed.dart';
part 'submit_answer.g.dart';

enum Region { north, south }

@freezed
class SubmitAnswer with _$SubmitAnswer {
  const factory SubmitAnswer({
    @Default(false) bool success,
    @JsonKey(name: 'star_count') @Default(0) int starCount,
    @JsonKey(name: 'total_score') @Default(0) int totalScore,
  }) = _SubmitAnswer;

  factory SubmitAnswer.fromJson(Map<String, dynamic> json) =>
      _$SubmitAnswerFromJson(json);
}
