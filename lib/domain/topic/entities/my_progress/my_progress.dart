// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';

part 'my_progress.freezed.dart';
part 'my_progress.g.dart';

@freezed
class MyProgress with _$MyProgress {
  const factory MyProgress({
    @JsonKey(name: 'topic_count') @Default(Count()) Count topicCount,
    @JsonKey(name: 'lesson_count') @Default(Count()) Count lessonCount,
    @JsonKey(name: 'star_count') @Default(Count()) Count starCount,
    @JsonKey(name: 'topics') @Default([]) List<Topic> topics,
  }) = _MyProgress;
  factory MyProgress.fromJson(Map<String, dynamic> json) =>
      _$MyProgressFromJson(json);
}
