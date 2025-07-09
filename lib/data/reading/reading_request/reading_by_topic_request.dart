import 'package:json_annotation/json_annotation.dart';

part 'reading_by_topic_request.g.dart';

@JsonSerializable()
class ReadingByTopicRequest {
  ReadingByTopicRequest({
    required this.categoryId,
    required this.studentId,
  });

  int categoryId;
  int studentId;

  factory ReadingByTopicRequest.fromJson(Map<String, dynamic> json) =>
      _$ReadingByTopicRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingByTopicRequestToJson(this);
}
