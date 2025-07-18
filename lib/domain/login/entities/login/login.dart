// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class Login with _$Login {
  const factory Login({
    @Default(-1) int id,

    @JsonKey(name: 'username')
    String? username,

    @JsonKey(name: 'email')
    @Default("") String email,

    @JsonKey(name: 'role_id') @Default('') String roleId,
    @Default("") String role,
    @Default("") String image,
    @JsonKey(name: 'accessToken') @Default("") String token,
  }) = _Login;

  factory Login.fromJson(Map<String, dynamic> json) =>
      _$LoginFromJson(json);
}

