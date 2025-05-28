// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities/child/child.dart';

part 'child_profiles.freezed.dart';
part 'child_profiles.g.dart';

@freezed
class ChildProfiles with _$ChildProfiles {
  const factory ChildProfiles({
    @JsonKey(name: 'child_profiles') @Default([]) List<Child> childProfiles,
  }) = _ChildProfiles;
  factory ChildProfiles.fromJson(Map<String, dynamic> json) =>
      _$ChildProfilesFromJson(json);
}
