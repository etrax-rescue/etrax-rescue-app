import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/backend/types/app_connection.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is properly formatted',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('app_connection/valid.json'));
        // act
        final result = AppConnection.fromJson(jsonMap);
        // assert
        expect(result, tAppConnection);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAppConnection.toJson();
        // assert
        final expectedJsonMap = {
          "authority": "etrax.at",
          "basePath": "appdata",
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
