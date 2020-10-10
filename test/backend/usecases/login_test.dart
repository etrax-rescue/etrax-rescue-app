import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/login_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/login.dart';

import '../../reference_types.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  Login usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = Login(mockLoginRepository);
  });

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
