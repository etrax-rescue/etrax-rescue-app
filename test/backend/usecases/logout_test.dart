import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/login_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/logout.dart';

import '../../reference_types.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  Logout usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = Logout(mockLoginRepository);
  });

  test(
    'should call logout on the repository',
    () async {
      // arrange
      when(mockLoginRepository.logout(any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(LogoutParams(
          appConnection: tAppConnection,
          authenticationData: tAuthenticationData));
      // assert
      expect(result, Right(None()));
      verify(mockLoginRepository.logout(tAppConnection, tAuthenticationData));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
