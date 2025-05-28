// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome.freezed.dart';
part 'welcome.g.dart';

@freezed
class Welcome with _$Welcome {
  const factory Welcome({
    @Default("") String message,
    @JsonKey(name: 'is_external_video') @Default(true) bool isExternalVideo,
    @Default("") String video,
  }) = _Welcome;
  factory Welcome.fromJson(Map<String, dynamic> json) =>
      _$WelcomeFromJson(json);
}
