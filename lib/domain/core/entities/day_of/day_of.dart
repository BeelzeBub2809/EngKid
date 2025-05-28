import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_of.freezed.dart';
part 'day_of.g.dart';

@freezed
class DayOf with _$DayOf {
  const factory DayOf({
    required String text,
    @Default('') String subText,
    @Default(0) double bottom,
    @Default(0) double left,
    @Default(0) double value,
    @Default(false) bool isHighlight,
  }) = _DayOf;

  factory DayOf.fromJson(Map<String, dynamic> json) => _$DayOfFromJson(json);
}
