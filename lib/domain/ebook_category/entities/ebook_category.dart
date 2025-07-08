// ebook_category.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebook_category.freezed.dart'; // File này sẽ được Freezed tạo ra
part 'ebook_category.g.dart';     // File này sẽ được json_serializable tạo ra

@freezed
class EBookCategory with _$EBookCategory {
  const factory EBookCategory({
    @Default(-1) int id, // Giá trị mặc định là -1 nếu 'id' không có
    @JsonKey(name: 'title') required String title, // Trường 'title' là bắt buộc
    @JsonKey(name: 'icon') required String iconUrl, // Thêm trường 'icon' và đổi tên thành iconUrl
    @JsonKey(name: 'image') required String imageUrl, // Đổi tên thuộc tính từ 'image' thành 'imageUrl' cho rõ ràng
  }) = _EBookCategory;

  // Factory constructor để chuyển đổi từ JSON Map sang đối tượng EBookCategory
  factory EBookCategory.fromJson(Map<String, dynamic> json) => _$EBookCategoryFromJson(json);
}