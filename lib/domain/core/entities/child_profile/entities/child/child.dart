// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    @JsonKey(name: 'user_id') @Default(1) int userId,
    @Default("") String name,
    @JsonKey(name: 'grade_id') @Default(1) int gradeId,
    @JsonKey(name: 'image') @Default("") String avatar,
    @JsonKey(name: 'is_passed_survey') @Default(0) int surveyPassed,
  }) = _Child;
  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
