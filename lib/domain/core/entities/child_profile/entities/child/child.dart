// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    @Default(-1) int id,
    @JsonKey(name: 'user_id') @Default(1) int userId,
    @Default("") String name,
    @JsonKey(name: 'grade_id') @Default(1) int gradeId,
    @JsonKey(name: 'image') @Default("") String avatar,
    @JsonKey(name: 'is_survey_passed') @Default(false) bool surveyPassed,
  }) = _Child;
  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
