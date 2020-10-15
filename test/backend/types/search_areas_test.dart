import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/search_area.dart';

import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('SearchArea', () {
    group('fromJson', () {
      test(
        'should throw a FormatException when the SearchArea has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/no_id.json'));
          // act & assert
          expect(() => SearchArea.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the SearchArea has no label field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/no_label.json'));
          // act & assert
          expect(() => SearchArea.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the SearchArea has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/no_description.json'));
          // act & assert
          expect(() => SearchArea.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the SearchArea has no coordinates field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/no_coordinates.json'));
          // act & assert
          expect(() => SearchArea.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the SearchArea has no color field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/no_color.json'));
          final t = SearchArea(
              id: tSearchAreaID,
              label: tSearchAreaLabel,
              description: tSearchAreaDescription,
              coordinates: tSearchAreaCoordinates);
          // act
          final result = SearchArea.fromJson(jsonMap);
          // assert
          expect(result, t);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('search_area/valid.json'));
          // act
          final result = SearchArea.fromJson(jsonMap);
          // assert
          expect(result, tSearchArea);
        },
      );
    });
  });

  group('SearchAreaCollection', () {
    group('fromJson', () {
      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final List<dynamic> jsonMap =
              json.decode(fixture('search_area_collection/valid.json'));
          // act
          final result = SearchAreaCollection.fromJson(jsonMap);
          // assert
          expect(result, tSearchAreaCollection);
        },
      );
    });
  });
}
