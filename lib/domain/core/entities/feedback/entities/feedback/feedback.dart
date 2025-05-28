// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/core/entities/entities.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

@freezed
class Feedback with _$Feedback {
  const factory Feedback({
    @JsonKey(name: 'id') @Default(-1) int id,
    @JsonKey(name: 'name') @Default("") String name,
    @JsonKey(name: 'user_id') @Default(-1) int userId,
    @JsonKey(name: 'user') @Default(User()) User user,
    // @JsonKey(name: 'category_id') @Default(-1) int categoryId,
    @JsonKey(name: 'categories') @Default([]) List<String> categories,
    @JsonKey(name: 'reading') @Default("") String reading,
    @JsonKey(name: 'grade') @Default("") String grade,
    @JsonKey(name: 'parent_id') @Default(-1) int parentId,
    @JsonKey(name: 'comment') @Default("") String comment,
    @JsonKey(name: 'status') @Default(0) int status,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'rating') @Default(0) int rating,
    @JsonKey(name: 'is_liked') @Default(0) int isLiked,
    @JsonKey(name: 'created_at') @Default("") String createdAt,
    @JsonKey(name: 'updated_at') @Default("") String updatedAt,
    @JsonKey(name: 'is_important') @Default(0) int isImportant,
    @JsonKey(name: 'children') @Default([]) List<Feedback> children,
  }) = _Feedback;
  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
}
