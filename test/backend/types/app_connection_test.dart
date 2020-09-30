import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('generateUri', () {
    test(
      'should return a valid uri when no parameters are given',
      () async {
        // act
        final result = tAppConnection.generateUri();
        // assert
        expect(result, equals(Uri.parse(p.join(tHost, tBasePath))));
      },
    );

    test(
      'should return a valid uri when a subPath is provided',
      () async {
        // arrange
        final tSubPath = 'test.php';
        // act
        final result = tAppConnection.generateUri(subPath: tSubPath);
        // assert
        expect(result, equals(Uri.parse(p.join(tHost, tBasePath, tSubPath))));
      },
    );

    test(
      'should return a valid uri when a subPath and a param map are provided',
      () async {
        // arrange
        final tSubPath = 'test.php';
        final tParamMap = {
          'username': 'JohnDoe',
        };
        // act
        final result =
            tAppConnection.generateUri(subPath: tSubPath, paramMap: tParamMap);
        // assert
        expect(
            result,
            equals(Uri.parse(
                'https://apptest.etrax.at/subdir/test.php?username=JohnDoe')));
      },
    );

    test(
      'should return a valid uri when no subPath but a param map is provided',
      () async {
        // arrange
        final tParamMap = {
          'username': 'JohnDoe',
        };
        // act
        final result = tAppConnection.generateUri(paramMap: tParamMap);
        // assert
        expect(
            result,
            equals(
                Uri.parse('https://apptest.etrax.at/subdir?username=JohnDoe')));
      },
    );
  });

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
          "host": "https://apptest.etrax.at",
          "basePath": "subdir",
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
