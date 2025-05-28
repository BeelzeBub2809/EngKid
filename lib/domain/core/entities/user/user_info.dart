// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/core/entities/user/entities/user/user.dart';

import 'entities/parent/parent.dart';
import 'entities/teacher/teacher.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @Default(User()) User user,
    @JsonKey(name: "parent_info") Parent? parentInfo,
    @JsonKey(name: "teacher_info") Teacher? teacherInfo,
  }) = _UserInfo;
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
