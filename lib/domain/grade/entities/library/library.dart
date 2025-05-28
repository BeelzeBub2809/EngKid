// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:EngKid/domain/grade/entities/entities.dart';

part 'library.freezed.dart';
part 'library.g.dart';

@freezed
class Library with _$Library {
  const factory Library({
    @JsonKey(name: 'my_library') @Default([]) List<Grade> myLibrary,
  }) = _Library;
  factory Library.fromJson(Map<String, dynamic> json) =>
      _$LibraryFromJson(json);
}
