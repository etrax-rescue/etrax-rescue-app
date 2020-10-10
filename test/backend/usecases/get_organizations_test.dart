import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/login_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_organizations.dart';

import '../../reference_types.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  GetOrganizations usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetOrganizations(mockLoginRepository);
  });

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
