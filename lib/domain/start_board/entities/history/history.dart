// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
class History with _$History {
  const factory History({
    @Default(-1) int id,
    @JsonKey(name: "kid_reading_id") @Default(-1) int readingId,
    @JsonKey(name: "title") @Default("") String readingTopic,
    @JsonKey(name: "date_reading") @Default("") String date,
    @Default(0) double star,
    @Default("") String duration,
    @JsonKey(name: "is_completed") @Default(0) int isCompleted,
  }) = _History;
  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
