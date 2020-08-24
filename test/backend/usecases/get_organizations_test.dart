import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/backend/types/organizations.dart';
import '../../../../lib/backend/domain/repositories/login_repository.dart';
import '../../../../lib/backend/domain/usecases/get_organizations.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  GetOrganizations usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetOrganizations(mockLoginRepository);
  });

  final tID = 'DEV';
  final tName = 'Rettungshunde';
  final tOrganization = Organization(id: tID, name: tName);
  final tOrganizationCollection =
      OrganizationCollection(organizations: <Organization>[tOrganization]);

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tGetOrganizationsParams =
      GetOrganizationsParams(appConnection: tAppConnection);

  test(
    'should return OrganizationCollection',
    () async {
      // arrange
      when(mockLoginRepository.getOrganizations(tAppConnection))
          .thenAnswer((_) async => Right(tOrganizationCollection));
      // act
      final result = await usecase(tGetOrganizationsParams);
      // assert
      expect(result, Right(tOrganizationCollection));
      verify(mockLoginRepository.getOrganizations(tAppConnection));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
