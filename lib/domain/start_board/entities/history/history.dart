// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
class History with _$History {
  const factory History({
    @Default("") String date,
    @Default(0) int time,
    @Default(0) double star,
    @Default("") String duration,
    @JsonKey(name: "reading_topic") @Default("") String readingTopic,
    @JsonKey(name: "reading_id") @Default("") String readingId,
  }) = _History;
  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
