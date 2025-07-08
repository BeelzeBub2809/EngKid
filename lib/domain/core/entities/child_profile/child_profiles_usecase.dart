import 'package:EngKid/domain/core/entities/child_profile/child_profiles.dart';
import 'package:EngKid/domain/core/entities/child_profile/child_repository.dart';

class ChildProfilesUsecases {
  final ChildRepository _childRepository;
  ChildProfilesUsecases(this._childRepository);

  Future<ChildProfiles> getAllKid(int kidParentId) async =>
      _childRepository.getAllKid(kidParentId);
}