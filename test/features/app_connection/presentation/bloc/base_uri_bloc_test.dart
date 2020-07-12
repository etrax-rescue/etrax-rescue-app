import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/messages/messages.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/usecases/verify_and_store_app_connection.dart';
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

  final tBaseUri = 'https://www.etrax.at';

  void mockInputConverterSuccess() =>
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tBaseUri));

  test(
    'should call the input converter first',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(ConnectApp(uriString: tBaseUri));
      await untilCalled(mockUriInputConverter.convert(any));
      // assert
      verify(mockUriInputConverter.convert(tBaseUri));
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
        AppConnectionError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(uriString: tBaseUri));
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
      bloc.add(ConnectApp(uriString: tBaseUri));
      await untilCalled(mockVerifyAndStoreAppConnection(any));
      // assert
      verify(mockVerifyAndStoreAppConnection(
          AppConnectionParams(baseUri: tBaseUri)));
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
      bloc.add(ConnectApp(uriString: tBaseUri));
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
        AppConnectionError(message: NETWORK_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(uriString: tBaseUri));
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
        AppConnectionError(message: SERVER_URL_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(uriString: tBaseUri));
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
        AppConnectionError(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(ConnectApp(uriString: tBaseUri));
    },
  );
}
