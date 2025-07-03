// ignore_for_file: invalid_annotation_target

import 'package:EngKid/utils/images.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    @Default(-1) int id,
    @JsonKey(name: 'title') @Default('') String name,
    @JsonKey(name: 'image') @Default('') String icon,
    @JsonKey(name: 'thmb_img') @Default(LocalImage.backgroundBlue) String thmbImg,
  }) = _Topic;
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
