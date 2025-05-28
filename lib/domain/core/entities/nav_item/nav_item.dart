import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_item.freezed.dart';

@freezed
class NavItem with _$NavItem {
  const factory NavItem({
    required String title,
    required bool isActive,
  }) = _NavItem;
}
