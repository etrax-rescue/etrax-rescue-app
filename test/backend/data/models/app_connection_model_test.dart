import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/backend/data/models/app_connection_model.dart';
import '../../../../lib/core/types/app_connection.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnectionModel =
      AppConnectionModel(authority: tAuthority, basePath: tBasePath);
  test(
    'should be a subclass of AppConnection entity',
    () async {
      // assert
      expect(tAppConnectionModel, isA<AppConnection>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is properly formatted',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('app_connection/valid.json'));
        // act
        final result = AppConnectionModel.fromJson(jsonMap);
        // assert
        expect(result, tAppConnectionModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAppConnectionModel.toJson();
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
