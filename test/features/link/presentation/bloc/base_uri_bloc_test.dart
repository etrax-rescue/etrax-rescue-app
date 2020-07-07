import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/messages/messages.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:etrax_rescue_app/features/link/domain/usecases/verify_and_store_base_uri.dart';
import 'package:etrax_rescue_app/features/link/presentation/bloc/base_uri_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockVerifyAndStoreBaseUri extends Mock implements VerifyAndStoreBaseUri {}

class MockUriInputConverter extends Mock implements UriInputConverter {}

void main() {
  BaseUriBloc bloc;
  MockVerifyAndStoreBaseUri mockVerifyAndStoreBaseUri;
  MockUriInputConverter mockUriInputConverter;

  setUp(() {
    mockVerifyAndStoreBaseUri = MockVerifyAndStoreBaseUri();
    mockUriInputConverter = MockUriInputConverter();
    bloc = BaseUriBloc(
        verifyAndStore: mockVerifyAndStoreBaseUri,
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
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
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
        BaseUriInitial(),
        BaseUriError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
    },
  );
  test(
    'should call usecase',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
      await untilCalled(mockVerifyAndStoreBaseUri(any));
      // assert
      verify(mockVerifyAndStoreBaseUri(BaseUriParams(baseUri: tBaseUri)));
    },
  );

  test(
    'should emit [BaseUriTesting, BaseUriStored] when base uri is stored successfully',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Right(None()));
      // assert
      final expected = [
        BaseUriInitial(),
        BaseUriVerifying(),
        BaseUriStored(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
    },
  );

  test(
    'should emit [BaseUriTesting, Error] when no network is available',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Left(NetworkFailure()));
      // assert
      final expected = [
        BaseUriInitial(),
        BaseUriVerifying(),
        BaseUriError(message: NETWORK_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
    },
  );

  test(
    'should emit [BaseUriTesting, Error] when the Server could not be reached, or when the server does not host an instance of eTrax|rescue',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [
        BaseUriInitial(),
        BaseUriVerifying(),
        BaseUriError(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
    },
  );

  test(
    'should emit [BaseUriTesting, Error] when storing of the uri failed',
    () async {
      // arrange
      mockInputConverterSuccess();
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [
        BaseUriInitial(),
        BaseUriVerifying(),
        BaseUriError(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(uriString: tBaseUri));
    },
  );
}
