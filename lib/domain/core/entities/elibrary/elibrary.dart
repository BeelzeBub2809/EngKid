// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'elibrary.freezed.dart';
part 'elibrary.g.dart';

@freezed
class Elibrary with _$Elibrary {
  const factory Elibrary({
    @Default(-1) int id,
    @JsonKey(name: 'name') @Default("") String name,
    @JsonKey(name: 'categories') @Default("") String categories,
    @JsonKey(name: 'thum_img') @Default("") String thum_img,
    @JsonKey(name: 'background') @Default("") String background,
    @JsonKey(name: 'reading_video') @Default("") String reading_video,
    @JsonKey(name: 'status') @Default(false) bool status,


  }) = _Elibrary;
  factory Elibrary.fromJson(Map<String, dynamic> json) => _$ElibraryFromJson(json);

}
