// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities/entities.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    @JsonKey(name: 'topic_readings')
    @Default(TopicReading())
        TopicReading topicReadings,
  }) = _Lesson;
  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
