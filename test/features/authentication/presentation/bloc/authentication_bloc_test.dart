import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/appconnect/domain/entities/base_uri.dart';
import 'package:etrax_rescue_app/common/appconnect/domain/usecases/get_base_uri.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/messages/messages.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLogin extends Mock implements Login {}

class MockGetBaseUri extends Mock implements GetBaseUri {}

void main() {
  AuthenticationBloc bloc;
  MockLogin mockLogin;
  MockGetBaseUri mockGetBaseUri;

  setUp(() {
    mockLogin = MockLogin();
    mockGetBaseUri = MockGetBaseUri();
    bloc = AuthenticationBloc(login: mockLogin, getBaseUri: mockGetBaseUri);
  });

  String tUsername = 'JohnDoe';
  String tPassword = '0123456789ABCDEF';
  String tBaseUri = 'https://etrax.at/appdata';

  void mockGetBaseUriSuccess() => when(mockGetBaseUri(any))
      .thenAnswer((_) async => Right(BaseUri(baseUri: tBaseUri)));

  test(
    'should retrieve stored base URI',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      await untilCalled(mockGetBaseUri(any));
      // assert
      verify(mockGetBaseUri(NoParams()));
    },
  );

  test(
    'should emit [Login, Error] when storing of the uri failed',
    () async {
      // arrange
      when(mockGetBaseUri(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        AuthenticationInitial(),
        AuthenticationVerifying(),
        AuthenticationError(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );

  test(
    'should retrieve stored base URI',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      await untilCalled(mockGetBaseUri(any));
      // assert
      verify(mockGetBaseUri(NoParams()));
    },
  );

  test(
    'should call usecase',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Right(None()));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      await untilCalled(mockLogin(any));
      // assert
      verify(mockLogin(LoginParams(
          baseUri: tBaseUri, username: tUsername, password: tPassword)));
    },
  );

  test(
    'should emit [AuthenticationVerifying, AuthenticationSuccess] when login was successful',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Right(None()));
      // assert
      final expected = [
        AuthenticationInitial(),
        AuthenticationVerifying(),
        AuthenticationSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );

  test(
    'should emit [AuthenticationVerifying, Error] when no network is available',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        AuthenticationInitial(),
        AuthenticationVerifying(),
        AuthenticationError(message: NETWORK_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );
  test(
    'should emit [AuthenticationVerifying, Error] when login failed',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(LoginFailure()));
      // assert
      final expected = [
        AuthenticationInitial(),
        AuthenticationVerifying(),
        AuthenticationError(message: LOGIN_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );

  test(
    'should emit [AuthenticationVerifying, Error] when a server failure occurs',
    () async {
      // arrange
      mockGetBaseUriSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        AuthenticationInitial(),
        AuthenticationVerifying(),
        AuthenticationError(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );
}
