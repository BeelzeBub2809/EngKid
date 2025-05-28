// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EzLish/domain/core/entities/feedback/entities/entities.dart';

part 'feedbacks.freezed.dart';
part 'feedbacks.g.dart';

@freezed
class Feedbacks with _$Feedbacks {
  const factory Feedbacks({
    @JsonKey(name: 'feedback') @Default([]) List<Feedback> feedback,
  }) = _Feedbacks;
  factory Feedbacks.fromJson(Map<String, dynamic> json) =>
      _$FeedbacksFromJson(json);
}
