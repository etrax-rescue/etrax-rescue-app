import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/usecases/delete_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/usecases/logout.dart';
import 'package:etrax_rescue_app/frontend/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/backend/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';
import 'package:etrax_rescue_app/backend/usecases/fetch_initialization_data.dart';
import 'package:etrax_rescue_app/frontend/missions/bloc/missions_bloc.dart';

import '../../../reference_types.dart';

class MockFetchInitializationData extends Mock
    implements FetchInitializationData {}

class MockGetAppConnection extends Mock implements GetAppConnection {}

class MockGetAuthenticationData extends Mock implements GetAuthenticationData {}

class MockDeleteToken extends Mock implements DeleteToken {}

void main() {
  InitializationBloc bloc;
  MockFetchInitializationData mockFetchInitializationData;
  MockGetAppConnection mockGetAppConnection;
  MockGetAuthenticationData mockGetAuthenticationData;
  MockDeleteToken mockDeleteToken;

  setUp(() {
    mockFetchInitializationData = MockFetchInitializationData();
    mockGetAppConnection = MockGetAppConnection();
    mockGetAuthenticationData = MockGetAuthenticationData();
    mockDeleteToken = MockDeleteToken();
    bloc = InitializationBloc(
        fetchInitializationData: mockFetchInitializationData,
        getAppConnection: mockGetAppConnection,
        getAuthenticationData: mockGetAuthenticationData,
        deleteToken: mockDeleteToken);
  });

  tearDown(() {
    bloc?.close();
  });

  void mockGetAppConnectionSuccess() => when(mockGetAppConnection(any))
      .thenAnswer((_) async => Right(tAppConnection));

  void mockGetAuthenticationDataSuccess() =>
      when(mockGetAuthenticationData(any))
          .thenAnswer((_) async => Right(tAuthenticationData));

  test(
    'should contain proper initial state',
    () async {
      // assert
      expect(bloc.state, InitializationState.initial());
    },
  );

  test(
    'should retrieve stored AppConnection',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tInitializationData));
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
          .thenAnswer((_) async => Right(tInitializationData));
      // act
      bloc.add(StartFetchingInitializationData());
      await untilCalled(mockGetAuthenticationData(any));
      // assert
      verify(mockGetAuthenticationData(NoParams()));
    },
  );

  test(
    'should emit [InProgress, UnrecoverableFailure] when retrieving of the AppConnection failed',
    () async {
      // arrange
      when(mockGetAppConnection(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.unrecoverableFailure,
            messageKey: FailureMessageKey.cache),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InProgress, UnrecoverableFailure] when retrieving of the AuthenticationData failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      when(mockGetAuthenticationData(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.unrecoverableFailure,
            messageKey: FailureMessageKey.cache),
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
          .thenAnswer((_) async => Right(tInitializationData));
      // act
      bloc.add(StartFetchingInitializationData());
      await untilCalled(mockFetchInitializationData(any));
      // assert
      verify(mockFetchInitializationData(FetchInitializationDataParams(
          appConnection: tAppConnection,
          authenticationData: tAuthenticationData)));
    },
  );

  test(
    'should emit [InProgress, InProgress, Success] when retrieving of the InitializationData succeeded',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Right(tInitializationData));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.inProgress,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData),
        InitializationState(
            status: InitializationStatus.success,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData,
            initializationData: tInitializationData),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InProgress, InProgress, UnrecoverableFailure] when storing the initialization data failed',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.inProgress,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData),
        InitializationState(
            status: InitializationStatus.unrecoverableFailure,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData,
            messageKey: FailureMessageKey.cache),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InProgress, InProgress, Failure] when no network connection is available',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.inProgress,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData),
        InitializationState(
            status: InitializationStatus.failure,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData,
            messageKey: FailureMessageKey.network),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InProgress, InProgress, Failure] when a server failure occurs',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.inProgress,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData),
        InitializationState(
            status: InitializationStatus.failure,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData,
            messageKey: FailureMessageKey.server),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );

  test(
    'should emit [InProgress, InProgress, UnrecoverableFailure] when an authentication failure occurs',
    () async {
      // arrange
      mockGetAppConnectionSuccess();
      mockGetAuthenticationDataSuccess();
      when(mockFetchInitializationData(any))
          .thenAnswer((_) async => Left(AuthenticationFailure()));
      // assert
      final expected = [
        InitializationState(status: InitializationStatus.inProgress),
        InitializationState(
            status: InitializationStatus.inProgress,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData),
        InitializationState(
            status: InitializationStatus.unrecoverableFailure,
            appConnection: tAppConnection,
            authenticationData: tAuthenticationData,
            messageKey: FailureMessageKey.authentication),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StartFetchingInitializationData());
    },
  );
}
