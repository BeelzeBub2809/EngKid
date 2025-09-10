
import 'package:EngKid/domain/core/entities/child_profile/child_profiles.dart';
import 'package:dio/dio.dart';

abstract class ChildRepository {
  Future<ChildProfiles> getAllKid(int kidParentId);
  Future<dynamic> createChild(Map<String, dynamic> body);
  Future<dynamic> updateChildProfile(int id,FormData formData);
}
