import 'package:json_annotation/json_annotation.dart';

part 'topic_reading_request.g.dart';

@JsonSerializable()
class TopicReadingRequest {
  TopicReadingRequest({
    this.pageNumb = 1,
    this.pageSize = 10,
    this.searchTerm = '',
    this.sort,
  });

  int pageNumb;
  int pageSize;
  String searchTerm;
  dynamic sort;

  factory TopicReadingRequest.fromJson(Map<String, dynamic> json) =>
      _$TopicReadingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TopicReadingRequestToJson(this);
}
