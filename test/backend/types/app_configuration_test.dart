import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:etrax_rescue_app/backend/types/app_configuration.dart';

import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('fromJson', () {
    test(
      'should return a valid model when the JSON is properly formatted',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('app_settings/valid.json'));
        // act
        final result = AppConfiguration.fromJson(jsonMap);
        // assert
        expect(result, tAppConfiguration);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAppConfiguration.toJson();
        // assert
        final expectedJsonMap = {
          "locationUpdateInterval": 0,
          "locationUpdateMinDistance": 50,
          "infoUpdateInterval": 300,
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
