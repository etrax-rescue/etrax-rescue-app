import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../../lib/backend/types/app_connection.dart';
import '../../fixtures/fixture_reader.dart';

void main() {
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  group('generateUri', () {
    test(
      'should return a valid uri when no parameters are given',
      () async {
        // act
        final result = tAppConnection.generateUri();
        // assert
        expect(result, equals(Uri.https(tAuthority, tBasePath)));
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
        expect(
            result, equals(Uri.https(tAuthority, tBasePath + '/' + tSubPath)));
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
            equals(
                Uri.https(tAuthority, p.join(tBasePath, tSubPath), tParamMap)));
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
        expect(result, equals(Uri.https(tAuthority, tBasePath, tParamMap)));
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
          "authority": "etrax.at",
          "basePath": "appdata",
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
