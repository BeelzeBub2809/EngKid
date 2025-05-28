import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_sequence_setting.freezed.dart';
part 'reading_sequence_setting.g.dart';

@freezed
class ReadingSequenceSetting with _$ReadingSequenceSetting {
  const factory ReadingSequenceSetting({
    @Default(true) bool readingSequenceSetting,
  }) = _ReadingSequenceSetting;

  factory ReadingSequenceSetting.fromJson(Map<String, dynamic> json) =>
      _$ReadingSequenceSettingFromJson(json);
}
