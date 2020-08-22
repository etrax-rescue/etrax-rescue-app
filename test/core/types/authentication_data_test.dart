import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/types/authentication_data.dart';

void main() {
  final String tOrganizationID = 'DEV';
  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationData tAuthenticationDataModel = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  group('generateAuthHeader', () {
    test(
      'should generate a properly formated Basic authentication header',
      () async {
        // arrange
        final tAuthString =
            base64.encode(utf8.encode('$tOrganizationID-$tUsername:$tToken'));
        final tHeader = {HttpHeaders.authorizationHeader: 'Basic $tAuthString'};
        // act
        final result = tAuthenticationDataModel.generateAuthHeader();
        // assert
        expect(result, equals(tHeader));
      },
    );
  });
}
