import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:etrax_rescue_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/get_authentication_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  GetAuthenticationData usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetAuthenticationData(mockAuthenticationRepository);
  });

  final String tToken = '0123456789ABCDEF';
  final String tUsername = 'JohnDoe';
  final AuthenticationData tAuthenticationData =
      AuthenticationData(username: tUsername, token: tToken);

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
