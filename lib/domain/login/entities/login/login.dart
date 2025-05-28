// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class Login with _$Login {
  const factory Login({
    @Default(-1) int id,
    @JsonKey(
      name: 'survey_passed',
    )
    @Default(false)
    bool surveyPassed,
    @Default("") String name,
    String? username,
    @Default("") String email,
    @Default("") String phone,
    @JsonKey(
      name: 'role_id',
    )
    @Default('')
    String roleId,
    @Default("") String role,
    @Default("") String image,
    @JsonKey(
      name: '_token',
    )
    @Default("")
    String token,
    @JsonKey(
      name: 'login_record',
    )
    @Default(0)
    int loginRecord,
  }) = _Login;
  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
}
