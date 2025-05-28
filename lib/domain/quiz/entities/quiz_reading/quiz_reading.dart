// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';

part 'quiz_reading.freezed.dart';
part 'quiz_reading.g.dart';

@freezed
class QuizReading with _$QuizReading {
  const factory QuizReading({
    @Default(-1) int id,
    @Default('') String name,
    @JsonKey(name: 'thum_img') @Default("") String thumImg,
    @Default('') String background,
    @Default('') String video,
    @Default('') String author,
    @JsonKey(name: 'video_mong') @Default("") String videoMong,
    @JsonKey(name: 'question_count') @Default(Count()) Count questionCount,
  }) = _QuizReading;
  factory QuizReading.fromJson(Map<String, dynamic> json) =>
      _$QuizReadingFromJson(json);
}
