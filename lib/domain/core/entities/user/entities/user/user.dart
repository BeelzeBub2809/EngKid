// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @Default(-1) int id,
    @Default("") String name,
    @Default("") String identity,
    @JsonKey(name: 'class') @Default('') String classname,
    @Default("") String grade,
    @Default("") String school,
    @Default("") String ward,
    @Default("") String district,
    // @Default("") String city,
    @Default("") String ethnic,
    @Default("") String email,
    @Default("") String image,
    @Default("") String phone,
    @Default("") String gender,
    @Default("") String dob,
    @JsonKey(name: 'language_name') @Default("") String languageName,
    @JsonKey(name: 'language_code') @Default("") String languageCode,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
