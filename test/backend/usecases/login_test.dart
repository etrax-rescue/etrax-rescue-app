import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/repositories/app_state_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/login.dart';

class MockAppStateRepository extends Mock implements AppStateRepository {}

void main() {
  Login usecase;
  MockAppStateRepository mockAppStateRepository;

  setUp(() {
    mockAppStateRepository = MockAppStateRepository();
    usecase = Login(mockAppStateRepository);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tLoginParams = LoginParams(
    appConnection: tAppConnection,
    organizationID: tOrganizationID,
    username: tUsername,
    password: tPassword,
  );
  test(
    'should return None when valid credentials are given',
    () async {
      // arrange
      when(mockAppStateRepository.login(any, any, any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(tLoginParams);
      // assert
      expect(result, Right(None()));
      verify(mockAppStateRepository.login(
          tAppConnection, tOrganizationID, tUsername, tPassword));
      verifyNoMoreInteractions(mockAppStateRepository);
    },
  );
}
