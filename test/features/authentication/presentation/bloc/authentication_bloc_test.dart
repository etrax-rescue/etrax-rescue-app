import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/mark_app_connection_for_update.dart';

class MockLogin extends Mock implements Login {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

class MockMarkAppConnectionForUpdate extends Mock
    implements MarkAppConnectionForUpdate {}

void main() {
  AuthenticationBloc bloc;
  MockLogin mockLogin;
  MockGetAppConnection mockGetAppConnection;
  MarkAppConnectionForUpdate mockMarkAppConnection;

  setUp(() {
    mockLogin = MockLogin();
    mockGetAppConnection = MockGetAppConnection();
    mockMarkAppConnection = MockMarkAppConnectionForUpdate();
    bloc = AuthenticationBloc(
      login: mockLogin,
      getAppConnection: mockGetAppConnection,
      markAppConnectionForUpdate: mockMarkAppConnection,
    );
  });

  tearDown(() {
    bloc?.close();
  });

  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  void mockGetAppConnectionSuccess() =>
      when(mockGetAppConnection(any)).thenAnswer((_) async =>
          Right(AppConnection(authority: tAuthority, basePath: tBasePath)));

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
    'should emit [AuthenticationInProgress, AuthenticationError] when storing of the uri failed',
    () async {
      // arrange
      when(mockGetAppConnection(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        AuthenticationInProgress(),
        AuthenticationError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
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
          appConnection: tAppConnection,
          username: tUsername,
          password: tPassword)));
    },
  );

  test(
    'should emit [AuthenticationInProgress, AuthenticationSuccess] when login was successful',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Right(None()));
      // assert
      final expected = [
        AuthenticationInProgress(),
        AuthenticationSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );

  test(
    'should emit [AuthenticationInProgress, AuthenticationError] when no network is available',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        AuthenticationInProgress(),
        AuthenticationError(messageKey: NETWORK_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );
  test(
    'should emit [AuthenticationInProgress, AuthenticationError] when login failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(LoginFailure()));
      // assert
      final expected = [
        AuthenticationInProgress(),
        AuthenticationError(messageKey: LOGIN_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );

  test(
    'should emit [AuthenticationInProgress, AuthenticationError] when a server failure occurs',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockLogin(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        AuthenticationInProgress(),
        AuthenticationError(messageKey: SERVER_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SubmitLogin(username: tUsername, password: tPassword));
    },
  );
}
