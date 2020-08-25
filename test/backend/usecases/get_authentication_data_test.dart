import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/repositories/app_state_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';

class MockAppStateRepository extends Mock implements AppStateRepository {}

void main() {
  GetAuthenticationData usecase;
  MockAppStateRepository mockAppStateRepository;

  setUp(() {
    mockAppStateRepository = MockAppStateRepository();
    usecase = GetAuthenticationData(mockAppStateRepository);
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
      when(mockAppStateRepository.getAuthenticationData())
          .thenAnswer((_) async => Right(tAuthenticationData));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAuthenticationData));
      verify(mockAppStateRepository.getAuthenticationData());
      verifyNoMoreInteractions(mockAppStateRepository);
    },
  );
}
