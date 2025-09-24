import 'package:EngKid/domain/core/entities/day_of/day_of.dart';
import 'package:json_annotation/json_annotation.dart';

part 'learning_path_stars.g.dart';

@JsonSerializable()
class LearningPathStars {
  @JsonKey(name: 'learning_path_id')
  final int learningPathId;

  @JsonKey(name: 'learning_path_name')
  final String learningPathName;

  @JsonKey(name: 'categories')
  final List<CategoryStars> categories;

  @JsonKey(name: 'total_stars')
  final int totalStars;

  @JsonKey(name: 'total_items')
  final int totalItems;

  @JsonKey(name: 'completed_items')
  final int completedItems;

  LearningPathStars({
    required this.learningPathId,
    required this.learningPathName,
    required this.categories,
    required this.totalStars,
    required this.totalItems,
    required this.completedItems,
  });

  factory LearningPathStars.fromJson(Map<String, dynamic> json) =>
      _$LearningPathStarsFromJson(json);

  Map<String, dynamic> toJson() => _$LearningPathStarsToJson(this);
}

@JsonSerializable()
class CategoryStars {
  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'category_name')
  final String categoryName;

  @JsonKey(name: 'total_stars')
  final int totalStars;

  @JsonKey(name: 'total_items')
  final int totalItems;

  @JsonKey(name: 'items_with_stars')
  final int itemsWithStars;

  CategoryStars({
    required this.categoryId,
    required this.categoryName,
    required this.totalStars,
    required this.totalItems,
    required this.itemsWithStars,
  });

  factory CategoryStars.fromJson(Map<String, dynamic> json) =>
      _$CategoryStarsFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryStarsToJson(this);
}

extension CategoryStarsExtension on CategoryStars {
  DayOf toDayOf() {
    return DayOf(
      text: categoryName,
      value: totalStars.toDouble(),
      isHighlight: itemsWithStars > 0,
    );
  }
}
