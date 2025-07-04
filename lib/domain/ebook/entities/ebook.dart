// ebook.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebook.freezed.dart'; // File này sẽ được Freezed tạo ra
part 'ebook.g.dart';     // File này sẽ được json_serializable tạo ra

@freezed
class EBook with _$EBook {
  const factory EBook({
    @Default(-1) int id,
    @JsonKey(name: 'title') required String title,
    @Default([]) List<int> categories,
    @JsonKey(name: 'image') required String image,
    @JsonKey(name: 'background') required String background,
    @JsonKey(name: 'file') required String file,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
  }) = _EBook;

  factory EBook.fromJson(Map<String, dynamic> json) => _$EBookFromJson(json);
}