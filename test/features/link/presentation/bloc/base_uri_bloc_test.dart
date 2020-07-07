import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
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
        store: mockVerifyAndStoreBaseUri,
        inputConverter: mockUriInputConverter);
  });

  final tBaseUri = 'https://www.etrax.at';

  test(
    'should call the input converter first',
    () async {
      // arrange
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tBaseUri));
      // act
      bloc.add(StoreBaseUri(tBaseUri));
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
        BaseUriError(message: null),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(StoreBaseUri(tBaseUri));
    },
  );
  test(
    'should call usecase',
    () async {
      // arrange
      when(mockUriInputConverter.convert(any)).thenReturn(Right(tBaseUri));
      when(mockVerifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Right(None()));
      // act
      bloc.add(StoreBaseUri(tBaseUri));
      await untilCalled(mockVerifyAndStoreBaseUri(baseUri: any));
      // assert
      verify(mockVerifyAndStoreBaseUri(baseUri: tBaseUri));
    },
  );
}
