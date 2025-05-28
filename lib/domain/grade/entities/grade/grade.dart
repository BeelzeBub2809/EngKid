// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade.freezed.dart';
part 'grade.g.dart';

@freezed
class Grade with _$Grade {
  const factory Grade({
    @Default(-1) int id,
    @Default("") String name,
    @Default("") String image,
    @JsonKey(name: 'time_limit') @Default('30') String timeLimit,
    @JsonKey(name: 'is_open') @Default(false) bool isOpen,
  }) = _Grade;
  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
}
