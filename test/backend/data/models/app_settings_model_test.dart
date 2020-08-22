import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/backend/data/models/app_settings_model.dart';
import '../../../../lib/backend/domain/entities/app_settings.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppSettingsModel = AppSettingsModel(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);
  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tAppSettingsModel, isA<AppSettings>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is properly formatted',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('app_settings/valid.json'));
        // act
        final result = AppSettingsModel.fromJson(jsonMap);
        // assert
        expect(result, tAppSettingsModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAppSettingsModel.toJson();
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
