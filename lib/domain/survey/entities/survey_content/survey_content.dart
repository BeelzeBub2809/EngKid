// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EzLish/domain/survey/entities/entities.dart';

part 'survey_content.freezed.dart';
part 'survey_content.g.dart';

@freezed
class SurveyContent with _$SurveyContent {
  const factory SurveyContent({
    @JsonKey(name: 'welcome_screens') Welcome? welcomeScreens,
  }) = _SurveyContent;
  factory SurveyContent.fromJson(Map<String, dynamic> json) =>
      _$SurveyContentFromJson(json);
}
