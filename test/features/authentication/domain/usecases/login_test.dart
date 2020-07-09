import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  Login usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = Login(mockAuthenticationRepository);
  });

  final tBaseUri = 'https://etrax.at/appdata';
  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tLoginParams = LoginParams(
    baseUri: tBaseUri,
    username: tUsername,
    password: tPassword,
  );
  test(
    'should return None when valid credentials are given',
    () async {
      // arrange
      when(mockAuthenticationRepository.login(any, any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(tLoginParams);
      // assert
      expect(result, Right(None()));
      verify(
          mockAuthenticationRepository.login(tBaseUri, tUsername, tPassword));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
