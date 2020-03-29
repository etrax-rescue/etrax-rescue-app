import 'dart:convert';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/person/data/datasources/person_info_local_data_source.dart';
import 'package:etrax_rescue_app/features/person/data/models/person_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  PersonInfoLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PersonInfoLocalDataSourceImpl(mockSharedPreferences);
  });

  final tPersonInfoModel =
      PersonInfoModel.fromJson(json.decode(fixture('person_info.json')));
  group('getCachedPersonInfo', () {
    test(
      'should return PersonInfo from the SharedPreferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('person_info.json'));
        // act
        final result = await dataSource.getCachedPersonInfo();
        // assert
        verify(mockSharedPreferences.getString(CACHE_PERSON_INFO));
        expect(result, equals(tPersonInfoModel));
      },
    );
    test(
      'should throw CacheException when the PersonInfo instance does not exist in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedPersonInfo;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cache PersonInfo', () {
    final tPersonInfoModel = PersonInfoModel(
        name: "John Doe",
        lastSeen: DateTime.parse("2020-02-02"),
        description: "Very Average Person");

    test(
      'should call SharedPreferences to store the data',
      () async {
        // act
        dataSource.cachePersonInfo(tPersonInfoModel);
        // assert
        final expectedJsonString = json.encode(tPersonInfoModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHE_PERSON_INFO, expectedJsonString));
      },
    );
  });
}
