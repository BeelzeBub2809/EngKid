import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/utils/localization/localization_service.dart';

part 'app_setting.freezed.dart';
part 'app_setting.g.dart';

enum Region { north, south }

@freezed
class AppSetting with _$AppSetting {
  const factory AppSetting({
    @Default(Language.vi) Language language,
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}
