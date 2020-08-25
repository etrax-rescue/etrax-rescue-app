import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import '../../fixtures/fixture_reader.dart';

void main() {
  final String tOrganizationID = 'DEV';
  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final DateTime tIssuingDate = DateTime.parse('2020-02-02T20:20:02');
  final AuthenticationData tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID,
      username: tUsername,
      token: tToken,
      issuingDate: tIssuingDate);

  group('generateAuthHeader', () {
    test(
      'should generate a properly formated Basic authentication header',
      () async {
        // arrange
        final tAuthString =
            base64.encode(utf8.encode('$tOrganizationID-$tUsername:$tToken'));
        final tHeader = {HttpHeaders.authorizationHeader: 'Basic $tAuthString'};
        // act
        final result = tAuthenticationData.generateAuthHeader();
        // assert
        expect(result, equals(tHeader));
      },
    );
  });

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
}
