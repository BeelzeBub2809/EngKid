import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu.freezed.dart';

@freezed
class Menu with _$Menu {
  const factory Menu({
    required String name,
    required String pathImage,
    required String to,
    required bool needValidateParent,
    required bool requireValidate,
    required dynamic arguments,
  }) = _Menu;
}
