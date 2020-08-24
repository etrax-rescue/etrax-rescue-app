import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/types/authentication_data.dart';
import '../../../../lib/backend/domain/repositories/login_repository.dart';
import '../../../../lib/backend/domain/usecases/get_authentication_data.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  GetAuthenticationData usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetAuthenticationData(mockLoginRepository);
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
      when(mockLoginRepository.getAuthenticationData())
          .thenAnswer((_) async => Right(tAuthenticationData));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAuthenticationData));
      verify(mockLoginRepository.getAuthenticationData());
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
