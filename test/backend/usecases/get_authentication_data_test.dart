import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/backend/repositories/login_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/repositories/mission_state_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';

import '../../reference_types.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  GetAuthenticationData usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetAuthenticationData(mockLoginRepository);
  });

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
