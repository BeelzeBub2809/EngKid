import 'package:EngKid/domain/core/entities/child_profile/child_profiles.dart';
import 'package:EngKid/domain/core/entities/child_profile/child_repository.dart';
import 'package:dio/dio.dart';

class ChildProfilesUsecases {
  final ChildRepository _childRepository;
  ChildProfilesUsecases(this._childRepository);

  Future<ChildProfiles> getAllKid(int kidParentId) async =>
      _childRepository.getAllKid(kidParentId);
  Future<dynamic> createChild(Map<String, dynamic> body) async =>
      _childRepository.createChild(body);
  Future<dynamic> updateChildProfile(int id, FormData formData) async =>
      _childRepository.updateChildProfile(id, formData);
}