import 'package:etrax_rescue_app/common/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/common/app_connection/data/datasources/app_connection_local_datasource.dart';
import 'package:etrax_rescue_app/common/app_connection/data/models/app_connection_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  AppConnectionLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AppConnectionLocalDataSourceImpl(mockSharedPreferences);
  });

  final String tUriString = 'https://www.etrax.at';
  final AppConnectionModel tBaseUriModel =
      AppConnectionModel(baseUri: tUriString);
  group('getCachedAppConnection', () {
    test(
      'should return AppConnectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(tUriString);
        // act
        final result = await dataSource.getCachedAppConnection();
        // assert
        verify(mockSharedPreferences.getString(CACHE_APP_CONNECTION));
        expect(result, equals(tBaseUriModel));
      },
    );

    test(
      'should throw CacheException when no AppConnection exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedAppConnection;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheAppConnection', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheAppConnection(tUriString);
        // assert
        verify(
            mockSharedPreferences.setString(CACHE_APP_CONNECTION, tUriString));
      },
    );
  });
}
