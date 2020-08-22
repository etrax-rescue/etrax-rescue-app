import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/domain/entities/organizations.dart';
import 'package:etrax_rescue_app/backend/domain/repositories/authentication_repository.dart';
import 'package:etrax_rescue_app/backend/domain/usecases/get_organizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  GetOrganizations usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetOrganizations(mockAuthenticationRepository);
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
      when(mockAuthenticationRepository.getOrganizations(tAppConnection))
          .thenAnswer((_) async => Right(tOrganizationCollection));
      // act
      final result = await usecase(tGetOrganizationsParams);
      // assert
      expect(result, Right(tOrganizationCollection));
      verify(mockAuthenticationRepository.getOrganizations(tAppConnection));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
