import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection_marked_for_update.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/verify_and_store_app_connection.dart';
import 'package:etrax_rescue_app/features/app_connection/presentation/bloc/app_connection_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockVerifyAndStoreAppConnection extends Mock
    implements VerifyAndStoreAppConnection {}

class MockGetAppConnectionMarkedForUpdate extends Mock
    implements GetAppConnectionMarkedForUpdate {}

class MockUriInputConverter extends Mock implements UriInputConverter {}

void main() {
  AppConnectionBloc bloc;
  MockVerifyAndStoreAppConnection mockVerifyAndStoreAppConnection;
  MockUriInputConverter mockUriInputConverter;
  MockGetAppConnectionMarkedForUpdate mockGetMarkedForUpdate;

  setUp(() {
    mockVerifyAndStoreAppConnection = MockVerifyAndStoreAppConnection();
    mockUriInputConverter = MockUriInputConverter();
    mockGetMarkedForUpdate = MockGetAppConnectionMarkedForUpdate();
    bloc = AppConnectionBloc(
        verifyAndStore: mockVerifyAndStoreAppConnection,
        inputConverter: mockUriInputConverter,
        markedForUpdate: mockGetMarkedForUpdate);
  });

  tearDown(() {
    bloc?.close();
  });

  final tAuthority = 'etrax.at';
  final tBasePath = SERVER_API_BASE_PATH;
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  void mockInputConverterSuccess() =>
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tAuthority));

  test(
    'should contain proper initial state',
    () async {
      // assert
      expect(bloc.state, AppConnectionInitial());
    },
  );

  test(
    'should call the input converter first',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
      await untilCalled(mockUriInputConverter.convert(any));
      // assert
      verify(mockUriInputConverter.convert(tAuthority));
    },
  );

  test(
    'should emit Error when input is invalid',
    () async {
      // arrange
      when(mockUriInputConverter.convert(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert
      final expected = [
        AppConnectionStateError(messageKey: INVALID_INPUT_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
    },
  );

  test(
    'should call usecase',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
      await untilCalled(mockVerifyAndStoreAppConnection(any));
      // assert
      verify(mockVerifyAndStoreAppConnection(
          AppConnectionParams(authority: tAuthority, basePath: tBasePath)));
    },
  );

  test(
    'should emit [AppConnectionVerifying, AppConnectionStored] when base uri is stored successfully',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // assert
      final expected = [
        AppConnectionStateInProgress(),
        AppConnectionStateSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
    },
  );

  test(
    'should emit [AppConnectionVerifying, Error] when no network is available',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        AppConnectionStateInProgress(),
        AppConnectionStateError(messageKey: NETWORK_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
    },
  );

  test(
    'should emit [AppConnectionVerifying, Error] when the Server could not be reached, or when the server does not host an instance of eTrax|rescue',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        AppConnectionStateInProgress(),
        AppConnectionStateError(messageKey: SERVER_URL_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
    },
  );

  test(
    'should emit [AppConnectionVerifying, Error] when storing of the uri failed',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        AppConnectionStateInProgress(),
        AppConnectionStateError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(AppConnectionEventConnect(authority: tAuthority));
    },
  );
}
