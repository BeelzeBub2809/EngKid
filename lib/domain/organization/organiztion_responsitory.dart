import 'package:EzLish/domain/organization/entities/entities.dart';

abstract class OrganizationRepository {
  Future<List<Organization>> getOrganization(int lever, int? parentId);
}
