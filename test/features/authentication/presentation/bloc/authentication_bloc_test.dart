import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/entities/app_connection.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/messages/messages.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLogin extends Mock implements Login {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

void main() {
  AuthenticationBloc bloc;
  MockLogin mockLogin;
  MockGetAppConnection mockGetAppConnection;

  setUp(() {
    mockLogin = MockLogin();
    mockGetAppConnection = MockGetAppConnection();
    bloc = AuthenticationBloc(
        login: mockLogin, getAppConnection: mockGetAppConnection);
  });

  String tUsername = 'JohnDoe';
  String tPassword = '0123456789ABCDEF';
  String tBaseUri = 'https://etrax.at/appdata';

  void mockGetAppConnectionSuccess() => when(mockGetAppConnection(any))
      .thenAnswer((_) async => Right(AppConnection(baseUri: tBaseUri)));

  test(
    'should retrieve stored base URI',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Right(None()));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      await untilCalled(mockGetAppConnection(any));
      // assert
      verify(mockGetAppConnection(NoParams()));
    },
  );

  test(
    'should emit [Login, Error] when storing of the uri failed',
    () async {
      // arrange
      when(mockGetAppConnection(any))
          .thenAnswer((_) async => Left(CacheFailure()));
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
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Right(None()));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      await untilCalled(mockGetAppConnection(any));
      // assert
      verify(mockGetAppConnection(NoParams()));
    },
  );

  test(
    'should call usecase',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
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
      mockGetAppConnectionSuccess();
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
      mockGetAppConnectionSuccess();
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
      mockGetAppConnectionSuccess();
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
      mockGetAppConnectionSuccess();
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
