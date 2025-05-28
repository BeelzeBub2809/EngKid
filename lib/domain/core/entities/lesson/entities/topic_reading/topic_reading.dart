// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/reading/reading.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';

part 'topic_reading.freezed.dart';
part 'topic_reading.g.dart';

@freezed
class TopicReading with _$TopicReading {
  const factory TopicReading({
    @Default(Topic()) Topic topic,
    @Default([]) List<Reading> readings,
  }) = _TopicReading;
  factory TopicReading.fromJson(Map<String, dynamic> json) =>
      _$TopicReadingFromJson(json);
}
