// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'name')  @Default("") String name,
    @JsonKey(name: 'parent_id') @Default(0) int parentId,
    @JsonKey(name: 'gender') @Default("") String gender,
    @JsonKey(name: 'dob') @Default("") String dob,
    @JsonKey(name: 'grade_id') @Default(1) int gradeId,
    @JsonKey(name: 'image') @Default("") String avatar
 }) = _Child;
  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
