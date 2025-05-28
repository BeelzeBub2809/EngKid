// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';

part 'progress_grade.freezed.dart';
part 'progress_grade.g.dart';

@freezed
class ProgressGrade with _$ProgressGrade {
  const factory ProgressGrade({
    @JsonKey(name: 'my_progress') @Default(MyProgress()) MyProgress myProgress,
  }) = _ProgressGrade;
  factory ProgressGrade.fromJson(Map<String, dynamic> json) =>
      _$ProgressGradeFromJson(json);
}
