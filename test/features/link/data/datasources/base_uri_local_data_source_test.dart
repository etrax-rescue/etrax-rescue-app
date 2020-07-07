import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/link/data/datasources/base_uri_local_datasource.dart';
import 'package:etrax_rescue_app/features/link/data/models/base_uri_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  BaseUriLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = BaseUriLocalDataSourceImpl(mockSharedPreferences);
  });

  final String tUriString = 'https://www.etrax.at';
  final BaseUriModel tBaseUriModel = BaseUriModel(baseUri: tUriString);
  group('getCachedBaseUri', () {
    test(
      'should return BaseUriModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(tUriString);
        // act
        final result = await dataSource.getCachedBaseUri();
        // assert
        verify(mockSharedPreferences.getString(CACHE_BASE_URI));
        expect(result, equals(tBaseUriModel));
      },
    );

    test(
      'should throw CacheException when no BaseUri exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedBaseUri;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheBaseUri', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheBaseUri(tUriString);
        // assert
        verify(mockSharedPreferences.setString(CACHE_BASE_URI, tUriString));
      },
    );
  });
}
