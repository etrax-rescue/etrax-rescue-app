import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/get_authentication_data.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/fetch_initialization_data.dart';
import 'package:etrax_rescue_app/features/initialization/presentation/bloc/initialization_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFetchInitializationData extends Mock
    implements FetchInitializationData {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

class MockGetAuthenticationData extends Mock implements GetAuthenticationData {}

void main() {
  InitializationBloc bloc;
  MockFetchInitializationData mockFetchInitializationData;
  MockGetAppConnection mockGetAppConnection;
  MockGetAuthenticationData mockGetAuthenticationData;

  setUp(() {
    mockFetchInitializationData = MockFetchInitializationData();
    mockGetAppConnection = MockGetAppConnection();
    mockGetAuthenticationData = MockGetAuthenticationData();
    bloc = InitializationBloc(
        fetchInitializationData: mockFetchInitializationData,
        getAppConnection: mockGetAppConnection,
        getAuthenticationData: mockGetAuthenticationData);
  });

  tearDown(() {
    bloc?.close();
  });

  final tAuthority = 'etrax.at';
  final tBasePath = SERVER_API_BASE_PATH;
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';

  final tMissionID = 42;
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tLatitude = 48.2206635;
  final tLongitude = 16.309849;
  final tMission = Mission(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollection = MissionCollection(missions: <Mission>[tMission]);

  void mockGetAppConnectionSuccess() =>
      when(mockGetAppConnection(any)).thenAnswer((_) async =>
          Right(AppConnection(authority: tAuthority, basePath: tBasePath)));

  void mockGetAuthenticationDataSuccess() =>
      when(mockGetAuthenticationData(any)).thenAnswer((_) async =>
          Right(AuthenticationData(username: tUsername, token: tToken)));

  test(
    'should retrieve stored AppConnection',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // act
      bloc.add(StartFetchingInitializationData());
      await untilCalled(mockGetAppConnection(any));
      // assert
      verify(mockGetAppConnection(NoParams()));
    },
  );

  test(
    'should retrieve stored AuthenticationData',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // act
      bloc.add(StartFetchingInitializationData());
      await untilCalled(mockGetAuthenticationData(any));
      // assert
      verify(mockGetAuthenticationData(NoParams()));
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when retrieving of the AppConnection failed',
    () async {
      // arrange
      when(mockGetAppConnection(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationUnrecoverableError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when retrieving of the AuthenticationData failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockGetAuthenticationData(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationUnrecoverableError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should call usecase',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // act
      bloc.add(StartFetchingInitializationData());
      await untilCalled(mockFetchInitializationData(any));
      // assert
      verify(mockFetchInitializationData(FetchInitializationDataParams(
          appConnection: tAppConnection, username: tUsername, token: tToken)));
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationSuccess] when retrieving of the AuthenticationData failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationSuccess(tMissionCollection),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when storing the initialization data failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationUnrecoverableError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when no network connection is available',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationRecoverableError(messageKey: NETWORK_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when a server failure occurs',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationRecoverableError(messageKey: SERVER_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationError] when an authentication failure occurs',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(AuthenticationFailure()));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationUnrecoverableError(
            messageKey: AUTHENTICATION_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InitializationInProgress, InitializationSuccess] when retrieving of the AuthenticationData failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // assert
      final expected = [
        InitializationInProgress(),
        InitializationSuccess(tMissionCollection),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );
}
