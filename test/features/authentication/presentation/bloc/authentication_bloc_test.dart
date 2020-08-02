import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/organizations_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/get_organizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/bloc/login_bloc.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/mark_app_connection_for_update.dart';

class MockLogin extends Mock implements Login {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

class MockGetOrganizations extends Mock implements GetOrganizations {}

class MockMarkAppConnectionForUpdate extends Mock
    implements MarkAppConnectionForUpdate {}

void main() {
  LoginBloc bloc;
  MockLogin mockLogin;
  MockGetOrganizations mockGetOrganizations;
  MockGetAppConnection mockGetAppConnection;
  MarkAppConnectionForUpdate mockMarkAppConnection;

  setUp(() {
    mockLogin = MockLogin();
    mockGetAppConnection = MockGetAppConnection();
    mockGetOrganizations = MockGetOrganizations();
    mockMarkAppConnection = MockMarkAppConnectionForUpdate();
    bloc = LoginBloc(
      login: mockLogin,
      getAppConnection: mockGetAppConnection,
      getOrganizations: mockGetOrganizations,
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

  final tID = 'DEV';
  final tName = 'Rettungshunde';
  final tOrganizationModel = OrganizationModel(id: tID, name: tName);
  final tOrganizationCollectionModel = OrganizationCollectionModel(
      organizations: <OrganizationModel>[tOrganizationModel]);

  void mockGetAppConnectionSuccess() =>
      when(mockGetAppConnection(any)).thenAnswer((_) async =>
          Right(AppConnection(authority: tAuthority, basePath: tBasePath)));

  test(
    'should contain proper initial state',
    () async {
      // assert
      expect(bloc.state, LoginInitial());
    },
  );

  group('SubmitLogin', () {
    test(
      'should retrieve stored app connection',
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
      'should emit [LoginInProgress, LoginError] when retrieving of the app connection failed',
      () async {
        // arrange
        when(mockGetAppConnection(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert
        final expected = [
          LoginInProgress(),
          LoginError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(username: tUsername, password: tPassword));
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
      'should emit [LoginInProgress, LoginSuccess] when login was successful',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockLogin(any)).thenAnswer((_) async => Right(None()));
        // assert
        final expected = [
          LoginInProgress(),
          LoginSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(username: tUsername, password: tPassword));
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
          LoginInProgress(),
          LoginError(messageKey: NETWORK_FAILURE_MESSAGE_KEY),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(username: tUsername, password: tPassword));
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
          LoginInProgress(),
          LoginError(messageKey: LOGIN_FAILURE_MESSAGE_KEY),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(username: tUsername, password: tPassword));
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
          LoginInProgress(),
          LoginError(messageKey: SERVER_FAILURE_MESSAGE_KEY),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitLogin(username: tUsername, password: tPassword));
      },
    );
  });

  group('LoginGetOrganizations', () {
    test(
      'should retrieve stored app connection',
      () async {
        // arrange
        mockGetAppConnectionSuccess();
        when(mockGetOrganizations(any))
            .thenAnswer((_) async => Right(tOrganizationCollectionModel));
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
            .thenAnswer((_) async => Right(tOrganizationCollectionModel));
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
            .thenAnswer((_) async => Right(tOrganizationCollectionModel));
        // assert
        final expected = [
          LoginReady(organizationCollection: tOrganizationCollectionModel),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(InitializeLogin());
      },
    );
  });
}
