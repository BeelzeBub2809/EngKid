// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    @Default(-1) int id,
    @JsonKey(name: 'user_id') @Default('') String userId,
    @Default("") String name,
    @JsonKey(name: 'class') @Default('') String classname,
    @JsonKey(name: 'login_id') @Default('') String loginId,
    @Default("") String grade,
    @Default("") String school,
    @Default("") String avatar,
    @JsonKey(name: 'survey_passed') @Default(false) bool surveyPassed,
  }) = _Child;
  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
