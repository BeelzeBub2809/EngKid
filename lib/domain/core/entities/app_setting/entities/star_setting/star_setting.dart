// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'star_setting.freezed.dart';
part 'star_setting.g.dart';

@freezed
class StarSetting with _$StarSetting {
  const factory StarSetting({
    @JsonKey(name: 'lesson_complete') @Default('1') String lessonComplete,
    @JsonKey(name: '1st_attempt') @Default('1') String stAttempt,
    @JsonKey(name: '2nd_attempt') @Default('1') String ndAttempt,
    @JsonKey(name: '3nd_attempt') @Default('1') String rdAttempt,
    @JsonKey(name: '4th_attempt') @Default('1') String thAttempt,
  }) = _StarSetting;

  factory StarSetting.fromJson(Map<String, dynamic> json) =>
      _$StarSettingFromJson(json);
}
