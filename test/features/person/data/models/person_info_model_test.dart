import 'dart:convert';

import 'package:etrax_rescue_app/features/person/data/models/person_info_model.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tPersonInfoModel = PersonInfoModel(
      name: "John Doe",
      lastSeen: DateTime.parse("2020-02-02T20:20:02.020"),
      description: "Very Average Person");

  test(
    'should be a subclass of PersonInfo entity',
    () async {
      // assert
      expect(tPersonInfoModel, isA<PersonInfo>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when only the required fields are provided in the JSON resonse',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('person_info.json'));
        // act
        final result = PersonInfoModel.fromJson(jsonMap);
        // assert
        expect(result, tPersonInfoModel);
      },
    );
  });
}
