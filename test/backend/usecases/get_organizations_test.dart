import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/organizations.dart';
import 'package:etrax_rescue_app/backend/repositories/mission_state_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_organizations.dart';

class MockAppStateRepository extends Mock implements MissionStateRepository {}

void main() {
  GetOrganizations usecase;
  MockAppStateRepository mockAppStateRepository;

  setUp(() {
    mockAppStateRepository = MockAppStateRepository();
    usecase = GetOrganizations(mockAppStateRepository);
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
      when(mockAppStateRepository.getOrganizations(tAppConnection))
          .thenAnswer((_) async => Right(tOrganizationCollection));
      // act
      final result = await usecase(tGetOrganizationsParams);
      // assert
      expect(result, Right(tOrganizationCollection));
      verify(mockAppStateRepository.getOrganizations(tAppConnection));
      verifyNoMoreInteractions(mockAppStateRepository);
    },
  );
}
