import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_array.freezed.dart';
part 'api_response_array.g.dart';

@freezed
class ApiResponseArray with _$ApiResponseArray {
  const factory ApiResponseArray({
    @Default(false) bool result,
    @Default('') String message,
    @Default([]) List<dynamic> data,
  }) = _ApiResponseArray;
  factory ApiResponseArray.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseArrayFromJson(json);
}
