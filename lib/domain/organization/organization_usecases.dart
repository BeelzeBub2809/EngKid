import 'package:EngKid/domain/organization/entities/entities.dart';
import 'package:EngKid/domain/organization/organiztion_responsitory.dart';

class OrganizationUseCases {
  final OrganizationRepository _organizationRepository;
  OrganizationUseCases(this._organizationRepository);

  Future<List<Organization>> getOrganization(
          {required int lever, int? parentId}) =>
      _organizationRepository.getOrganization(lever, parentId);
}
