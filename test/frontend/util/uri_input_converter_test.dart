import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/error/failures.dart';
import '../../../lib/frontend/util/uri_input_converter.dart';
import '../../reference_types.dart';

void main() {
  UriInputConverter inputConverter;
  setUp(() {
    inputConverter = UriInputConverter();
  });

  // TODO: handle the case where the eTrax server is installed in a subdirectory. Thus the uri would look something like: organization.org/etrax/appdata
  group('convert', () {
    test(
      'should return the the input string if a valid authority string is given',
      () async {
        // act
        final result = inputConverter.convert(tHost);
        // assert
        expect(result, Right(tHost));
      },
    );
    test(
      'should return a InvalidInputFailure when an authority string with query param is given',
      () async {
        // arrange
        final tBadUri = 'https://etrax.at/?test=foo';
        // act
        final result = inputConverter.convert(tBadUri);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );

    test(
      'should return a InvalidInputFailure when the provided authority string contains whitespaces',
      () async {
        // arrange
        final tBadAuthority = 'https://www etrax.at/';
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
        final tUri = 'https://apptest.etrax.at/';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tHost));
      },
    );
    test(
      'should work with authority strings that include www',
      () async {
        // arrange
        final tUri = 'https://www.etrax.at';
        // act
        final result = inputConverter.convert(tUri);
        // assert
        expect(result, Right(tUri));
      },
    );
  });
}
