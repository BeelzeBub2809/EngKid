import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_object.freezed.dart';
part 'api_response_object.g.dart';

@freezed
class ApiResponseObject with _$ApiResponseObject {
  const factory ApiResponseObject({
    @JsonKey(name: "success") @Default(false) bool result,
    @Default('') String message,
    @Default({}) dynamic data,
    @JsonKey(name: "status") @Default(0) int code,
  }) = _ApiResponseObject;
  factory ApiResponseObject.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseObjectFromJson(json);
}
