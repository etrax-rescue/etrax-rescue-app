import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/backend/usecases/scan_qr_code.dart';
import 'package:etrax_rescue_app/backend/usecases/set_app_connection.dart';
import 'package:etrax_rescue_app/frontend/app_connection/cubit/app_connection_cubit.dart';
import 'package:etrax_rescue_app/frontend/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/frontend/util/uri_input_converter.dart';

import '../../../reference_types.dart';

class MockSetAppConnection extends Mock implements SetAppConnection {}

class MockScanQrCode extends Mock implements ScanQrCode {}

class MockUriInputConverter extends Mock implements UriInputConverter {}

void main() {
  AppConnectionCubit cubit;
  MockSetAppConnection mockSetAppConnection;
  MockUriInputConverter mockUriInputConverter;
  MockScanQrCode mockScanQrCode;

  setUp(() {
    mockSetAppConnection = MockSetAppConnection();
    mockUriInputConverter = MockUriInputConverter();
    mockScanQrCode = MockScanQrCode();
    cubit = AppConnectionCubit(
        inputConverter: mockUriInputConverter,
        scanQrCode: mockScanQrCode,
        setAppConnection: mockSetAppConnection);
  });

  tearDown(() {
    cubit?.close();
  });

  test(
    'should contain proper initial state',
    () async {
      // assert
      expect(cubit.state, AppConnectionState.initial());
    },
  );

  void mockInputConverterSuccess() =>
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tHost));

  group('submit', () {
    test(
      'should call the input converter first',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any)).thenAnswer((_) async => Right(None()));
        // act
        cubit.submit(tHost);
        await untilCalled(mockUriInputConverter.convert(any));
        // assert
        verify(mockUriInputConverter.convert(tHost));
      },
    );

    test(
      'should emit AppConnectionStateError when input is invalid',
      () async {
        // arrange
        when(mockUriInputConverter.convert(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert
        final expected = [
          AppConnectionState(
              status: AppConnectionStatus.error,
              connectionString: null,
              messageKey: FailureMessageKey.invalidInput),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        cubit.submit(tHost);
      },
    );

    test(
      'should call SetAppConnection',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any)).thenAnswer((_) async => Right(None()));
        // act
        cubit.submit(tHost);
        await untilCalled(mockSetAppConnection(any));
        // assert
        verify(mockSetAppConnection(AppConnectionParams(
            authority: tHost, basePath: SERVER_API_BASE_PATH)));
      },
    );

    test(
      'should emit [AppConnectionVerifying, AppConnectionStored] when base uri is stored successfully',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any)).thenAnswer((_) async => Right(None()));
        // assert
        final expected = [
          AppConnectionState(
              status: AppConnectionStatus.loading,
              connectionString: tHost,
              messageKey: null),
          AppConnectionState.success(),
        ];
        expectLater(cubit, emitsInOrder(expected));
        // act
        cubit.submit(tHost);
      },
    );

    test(
      'should emit [AppConnectionStateInProgress, AppConnectionStateError] when no network is available',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any))
            .thenAnswer((_) async => Left(NetworkFailure()));
        // assert
        final expected = [
          AppConnectionState(
              status: AppConnectionStatus.loading,
              connectionString: tHost,
              messageKey: null),
          AppConnectionState(
              status: AppConnectionStatus.error,
              connectionString: tHost,
              messageKey: FailureMessageKey.network),
        ];
        expectLater(cubit, emitsInOrder(expected));
        // act
        cubit.submit(tHost);
      },
    );

    test(
      'should emit [AppConnectionStateInProgress, AppConnectionStateError] when the Server could not be reached, or when the server does not host an instance of eTrax|rescue',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        final expected = [
          AppConnectionState(
              status: AppConnectionStatus.loading,
              connectionString: tHost,
              messageKey: null),
          AppConnectionState(
              status: AppConnectionStatus.error,
              connectionString: tHost,
              messageKey: FailureMessageKey.server),
        ];
        expectLater(cubit, emitsInOrder(expected));
        // act
        cubit.submit(tHost);
      },
    );

    test(
      'should emit [AppConnectionStateInProgress, AppConnectionStateError] when storing of the uri failed',
      () async {
        // arrange
        mockInputConverterSuccess();
        when(mockSetAppConnection(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          AppConnectionState(
              status: AppConnectionStatus.loading,
              connectionString: tHost,
              messageKey: null),
          AppConnectionState(
              status: AppConnectionStatus.error,
              connectionString: tHost,
              messageKey: FailureMessageKey.cache),
        ];
        expectLater(cubit, emitsInOrder(expected));
        // act
        cubit.submit(tHost);
      },
    );
  });
}
