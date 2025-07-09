
import 'package:EngKid/domain/core/entities/child_profile/child_profiles.dart';

abstract class ChildRepository {
  Future<ChildProfiles> getAllKid(int kidParentId);
}
