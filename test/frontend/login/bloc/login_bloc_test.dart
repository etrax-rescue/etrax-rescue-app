import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/frontend/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/usecases/login.dart';
import 'package:etrax_rescue_app/frontend/login/bloc/login_bloc.dart';
import 'package:etrax_rescue_app/backend/usecases/get_organizations.dart';
import 'package:etrax_rescue_app/backend/usecases/delete_app_connection.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';

import '../../../reference_types.dart';

class MockLogin extends Mock implements Login {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

class MockGetOrganizations extends Mock implements GetOrganizations {}

class MockGetAuthenticationData extends Mock implements GetAuthenticationData {}

class MockDeleteAppConnection extends Mock implements DeleteAppConnection {}

void main() {
  LoginBloc bloc;
  MockLogin mockLogin;
  MockGetOrganizations mockGetOrganizations;
  MockGetAppConnection mockGetAppConnection;
  MockDeleteAppConnection mockDeleteAppConnection;
  MockGetAuthenticationData mockGetAuthenticationData;

  setUp(() {
    mockLogin = MockLogin();
    mockGetAppConnection = MockGetAppConnection();
    mockGetOrganizations = MockGetOrganizations();
    mockDeleteAppConnection = MockDeleteAppConnection();
    mockGetAuthenticationData = MockGetAuthenticationData();
    bloc = LoginBloc(
      login: mockLogin,
      getAppConnection: mockGetAppConnection,
      getOrganizations: mockGetOrganizations,
      deleteAppConnection: mockDeleteAppConnection,
      getAuthenticationData: mockGetAuthenticationData,
    );
  });

  tearDown(() {
    bloc?.close();
  });

  void mockGetAppConnectionSuccess() => when(mockGetAppConnection(any))
      .thenAnswer((_) async => Right(tAppConnection));

  test(
    'should contain proper initial state',
    () async {
      // assert
      expect(bloc.state, LoginInitial());
    },
  );

  group('InitializeLogin', () {
    test(
      'should fetch organizations and cached username',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockGetOrganizations(any))
            .thenAnswer((_) async => Right(tOrganizationCollection));
        when(mockGetAuthenticationData(any))
            .thenAnswer((_) async => Right(tAuthenticationData));
        // assert
        final expected = [
          LoginReady(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: tOrganizationCollection),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(InitializeLogin());
      },
    );
    test(
      'should retrieve stored app connection',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockGetOrganizations(any))
            .thenAnswer((_) async => Right(tOrganizationCollection));
        when(mockGetAuthenticationData(any))
            .thenAnswer((_) async => Right(tAuthenticationData));
        // act
        bloc.add(InitializeLogin());
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
        when(mockGetOrganizations(any))
            .thenAnswer((_) async => Right(tOrganizationCollection));
        when(mockGetAuthenticationData(any))
            .thenAnswer((_) async => Right(tAuthenticationData));
        // act
        bloc.add(InitializeLogin());
        await untilCalled(mockGetOrganizations(any));
        // assert
        verify(mockGetOrganizations(
            GetOrganizationsParams(appConnection: tAppConnection)));
      },
    );

    test(
      'should emit [LoginReady] when getting organizations was successful',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockGetOrganizations(any))
            .thenAnswer((_) async => Right(tOrganizationCollection));
        when(mockGetAuthenticationData(any))
            .thenAnswer((_) async => Right(tAuthenticationData));
        // assert
        final expected = [
          LoginReady(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: tOrganizationCollection),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(InitializeLogin());
      },
    );
  });

  group('SubmitLogin', () {
    test(
      'should retrieve stored app connection',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Right(None()));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
        await untilCalled(mockGetAppConnection(any));
        // assert
        verify(mockGetAppConnection(NoParams()));
      },
    );

    test(
      'should emit [LoginInProgress, LoginError] when retrieving of the app connection failed',
      () async {
        // arrange
        when(mockGetAppConnection(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert
        final expected = [
          LoginInProgress(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null),
          LoginError(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null,
              messageKey: FailureMessageKey.cache),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
      },
    );

    test(
      'should call usecase',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Right(None()));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
        await untilCalled(mockLogin(any));
        // assert
        verify(mockLogin(LoginParams(
            appConnection: tAppConnection,
            organizationID: tOrganizationID,
            username: tUsername,
            password: tPassword)));
      },
    );

    test(
      'should emit [LoginInProgress, LoginSuccess] when login was successful',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Right(None()));
        // assert
        final expected = [
          LoginInProgress(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null),
          LoginSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
      },
    );

    test(
      'should emit [LoginInProgress, LoginError] when no network is available',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Left(NetworkFailure()));
        // assert
        final expected = [
          LoginInProgress(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null),
          LoginError(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null,
              messageKey: FailureMessageKey.network),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
      },
    );
    test(
      'should emit [LoginInProgress, LoginError] when login failed',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Left(LoginFailure()));
        // assert
        final expected = [
          LoginInProgress(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null),
          LoginError(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null,
              messageKey: FailureMessageKey.login),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
      },
    );

    test(
      'should emit [LoginInProgress, LoginError] when a server failure occurs',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert
        final expected = [
          LoginInProgress(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null),
          LoginError(
              username: tUsername,
              organizationID: tOrganizationID,
              organizations: null,
              messageKey: FailureMessageKey.server),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(
            username: tUsername,
            password: tPassword,
            organizationID: tOrganizationID));
      },
    );
  });
}
