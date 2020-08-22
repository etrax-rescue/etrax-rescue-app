import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../lib/backend/types/authentication_data.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final String tOrganizationID = 'DEV';
  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationData tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);
  test(
    'should be a subclass of LoginData entity',
    () async {
      // assert
      expect(tAuthenticationData, isA<AuthenticationData>());
    },
  );

  group('fromJson', () {
    test(
      'should throw a FormatException when the json map is missing the token field',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication_data/token_missing.json'));
        // assert
        expect(() => AuthenticationData.fromJson(jsonMap),
            throwsA(TypeMatcher<FormatException>()));
      },
    );

    test(
      'should throw a FormatException when the json map is missing the organization id field',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
            fixture('authentication_data/organization_id_missing.json'));
        // assert
        expect(() => AuthenticationData.fromJson(jsonMap),
            throwsA(TypeMatcher<FormatException>()));
      },
    );

    test(
      'should return a valid model when only the required fields are provided in the JSON resonse',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication_data/valid.json'));
        // act
        final result = AuthenticationData.fromJson(jsonMap);
        // assert
        expect(result, tAuthenticationData);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAuthenticationData.toJson();
        // assert
        final expectedMap = {
          'organizationID': tOrganizationID,
          'username': tUsername,
          'token': tToken,
        };
        expect(result, equals(expectedMap));
      },
    );
  });
}
