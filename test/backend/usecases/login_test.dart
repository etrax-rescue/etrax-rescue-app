import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/backend/domain/repositories/login_repository.dart';
import '../../../../lib/backend/domain/usecases/login.dart';

class MockAuthenticationRepository extends Mock implements LoginRepository {}

void main() {
  Login usecase;
  MockAuthenticationRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockAuthenticationRepository();
    usecase = Login(mockLoginRepository);
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
      when(mockLoginRepository.login(any, any, any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(tLoginParams);
      // assert
      expect(result, Right(None()));
      verify(mockLoginRepository.login(
          tAppConnection, tOrganizationID, tUsername, tPassword));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
