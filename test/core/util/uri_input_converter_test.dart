import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UriInputConverter inputConverter;
  setUp(() {
    inputConverter = UriInputConverter();
  });
  final tAuthority = 'etrax.at';

  // TODO: handle the case where the eTrax server is installed in a subdirectory. Thus the uri would look something like: organization.org/etrax/appdata
  group('convert', () {
    test(
      'should return the the input string if a valid authority string is given',
      () async {
        // act
        final result = inputConverter.convert(tAuthority);
        // assert
        expect(result, Right(tAuthority));
      },
    );
    test(
      'should return a InvalidInputFailure when an authority string with query param is given',
      () async {
        // arrange
        final tBadUri = 'etrax.at/?test=foo';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when an authority string with schema is given',
      () async {
        // arrange
        final tBadAuthority = 'https://www.etrax.at';
        // act
        final result = inputConverter.convert(tBadAuthority);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when the provided authority string contains whitespaces',
      () async {
        // arrange
        final tBadAuthority = 'www etrax.at/';
        // act
        final result = inputConverter.convert(tBadAuthority);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should return a InvalidInputFailure when a FormatException occurs',
      () async {
        // arrange
        final tBadAuthority = 'Müsli';
        // act
        final result = inputConverter.convert(tBadAuthority);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
    test(
      'should remove trailing backslash from authority string',
      () async {
        // arrange
        final tUri = 'etrax.at/';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tAuthority));
      },
    );
    test(
      'should work with authority strings that include www',
      () async {
        // arrange
        final tUri = 'www.etrax.at';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tUri));
      },
    );
  });
}
