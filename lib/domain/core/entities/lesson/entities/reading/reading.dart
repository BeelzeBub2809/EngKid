// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading.freezed.dart';
part 'reading.g.dart';

@freezed
class Reading with _$Reading {
  const factory Reading({
    @Default(-1) int id,
    @Default(0) int stars,
    @JsonKey(name: 'achieved_stars') @Default(0.0) double achievedStars,
    @Default(0.0) double maxAchievedStars,
    @Default("") String name,
    @JsonKey(name: 'thum_img') @Default("") String thumImg,
    @Default("") String background,
    @JsonKey(name: 'reading_video') @Default("") String readingVideo,
    @JsonKey(name: 'is_action_game') @Default(false) bool isActionGame,
    @JsonKey(name: 'is_locked') @Default(true) bool isLocked,
    @JsonKey(name: 'total_quiz') @Default(-1) int totalQuiz,
    @JsonKey(name: 'total_complete_quiz') @Default(-1) int totalCompleteQuiz,
    @JsonKey(name: 'position_id') @Default(-1) int positionId,
    @JsonKey(name: 'reading_video_mong') @Default("") String readingVideoMong,

    @Default(-1) int percentage,
  }) = _Reading;
  factory Reading.fromJson(Map<String, dynamic> json) =>
      _$ReadingFromJson(json);
}
