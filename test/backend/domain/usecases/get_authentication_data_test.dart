import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/core/types/usecase.dart';
import '../../../../lib/core/types/authentication_data.dart';
import '../../../../lib/backend/domain/repositories/authentication_repository.dart';
import '../../../../lib/backend/domain/usecases/get_authentication_data.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  GetAuthenticationData usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetAuthenticationData(mockAuthenticationRepository);
  });

  final String tOrganizationID = 'DEV';
  final String tToken = '0123456789ABCDEF';
  final String tUsername = 'JohnDoe';
  final AuthenticationData tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  test(
    'should return AuthenticationData when they are available',
    () async {
      // arrange
      when(mockAuthenticationRepository.getAuthenticationData())
          .thenAnswer((_) async => Right(tAuthenticationData));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAuthenticationData));
      verify(mockAuthenticationRepository.getAuthenticationData());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
