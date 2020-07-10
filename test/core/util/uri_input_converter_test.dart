import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UriInputConverter inputConverter;
  setUp(() {
    inputConverter = UriInputConverter();
  });

  final tBaseUri = 'https://www.etrax.at';
  group('convert', () {
    test(
      'should return the the input string if a valid url string is given',
      () async {
        // act
        final result = inputConverter.convert(tBaseUri);
        // assert
        expect(result, Right(tBaseUri));
      },
    );
    test(
      'should return a InvalidInputFailure when a uri with query param is given',
      () async {
        // arrange
        final tBadUri = 'https://www.etrax.at/?test=foo';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when a uri without schema is given',
      () async {
        // arrange
        final tBadUri = '/www.etrax.at/';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when the provided uri contains whitespaces',
      () async {
        // arrange
        final tBadUri = 'https://www etrax.at/';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when a non https uri is given',
      () async {
        // arrange
        final tBadUri = 'http://www.etrax.at/';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should remove trailing backslash from uri',
      () async {
        // arrange
        final tUri = 'https://www.etrax.at/';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tBaseUri));
      },
    );
    test(
      'should work with uris that do not include www',
      () async {
        // arrange
        final tUri = 'https://etrax.at';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tUri));
      },
    );
  });
}
