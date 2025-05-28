// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'option.freezed.dart';
part 'option.g.dart';

@freezed
class Option with _$Option {
  const factory Option({
    @JsonKey(name: 'option_id') @Default(-1) int optionId,
    @Default("") String image,
    @JsonKey(name: 'is_correct') @Default("") String isCorrect,
    @Default("") String option,
    @Default(false) bool isChecked, // dành cho single choice
    @Default(-1) int position, // dành cho xếp hình và matching
    @Default(-1) int positionOriginal, // dành cho matching
    @Default("0") String order, // dành cho xếp hình
    @Default([]) List<int> checkedAnswer,
    @JsonKey(name: 'option_type')
    @Default('')
        String optionType, // dành cho matching
    @JsonKey(name: 'key_position')
    @Default(0)
    int keyPosition,
  }) = _Option;
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}
