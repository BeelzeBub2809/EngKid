// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EzLish/domain/core/entities/lesson/entities/entities.dart';

part 'grade_reading.freezed.dart';
part 'grade_reading.g.dart';

@freezed
class GradeReading with _$GradeReading {
  const factory GradeReading({
    @JsonKey(name: 'reading') @Default([]) List<Reading> reading,
  }) = _GradeReading;
  factory GradeReading.fromJson(Map<String, dynamic> json) =>
      _$GradeReadingFromJson(json);
}
