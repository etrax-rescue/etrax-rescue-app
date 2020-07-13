import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/verify_and_store_app_connection.dart';
import 'package:etrax_rescue_app/features/app_connection/presentation/bloc/app_connection_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockVerifyAndStoreAppConnection extends Mock
    implements VerifyAndStoreAppConnection {}

class MockUriInputConverter extends Mock implements UriInputConverter {}

void main() {
  AppConnectionBloc bloc;
  MockVerifyAndStoreAppConnection mockVerifyAndStoreAppConnection;
  MockUriInputConverter mockUriInputConverter;

  setUp(() {
    mockVerifyAndStoreAppConnection = MockVerifyAndStoreAppConnection();
    mockUriInputConverter = MockUriInputConverter();
    bloc = AppConnectionBloc(
        verifyAndStore: mockVerifyAndStoreAppConnection,
        inputConverter: mockUriInputConverter);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  void mockInputConverterSuccess() =>
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tAuthority));

  test(
    'should call the input converter first',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
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
        AppConnectionInitial(),
        AppConnectionError(messageKey: INVALID_INPUT_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
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
      bloc.add(ConnectApp(authority: tAuthority));
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
        AppConnectionInitial(),
        AppConnectionVerifying(),
        AppConnectionSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
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
        AppConnectionInitial(),
        AppConnectionVerifying(),
        AppConnectionError(messageKey: NETWORK_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
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
        AppConnectionInitial(),
        AppConnectionVerifying(),
        AppConnectionError(messageKey: SERVER_URL_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
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
        AppConnectionInitial(),
        AppConnectionVerifying(),
        AppConnectionError(messageKey: CACHE_FAILURE_MESSAGE_KEY),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(authority: tAuthority));
    },
  );
}
