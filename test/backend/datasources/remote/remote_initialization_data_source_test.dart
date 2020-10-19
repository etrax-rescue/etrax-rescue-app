import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_initialization_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteInitializationDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteInitializationDataSourceImpl(mockedHttpClient);
  });

  test(
    'should perform a GET request on the initialization endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('initialization/valid.json'), 200));
      final uri = tAppConnection.generateUri(
          subPath: EtraxServerEndpoints.initialization);
      // act
      await remoteDataSource.fetchInitialization(
          tAppConnection, tAuthenticationData);
      // assert
      verify(mockedHttpClient.get(uri,
          headers: tAuthenticationData.generateAuthHeader()));
    },
  );

  test(
    'should throw a ServerException when a HTTP client exception occurs ',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers')))
          .thenThrow(http.ClientException(''));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a ServerException when the response is empty',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw an AuthenticationException when the server responds with code 401',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 401));
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<AuthenticationException>()));
    },
  );

  test(
    'should throw a ServerException when the JSON response is missing the appConfiguration field',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('initialization/app_settings_missing.json'), 200));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a ServerException when the JSON response is missing the roles field',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('initialization/roles_missing.json'), 200));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a ServerException when the JSON response is missing the missions field',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('initialization/missions_missing.json'), 200));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a ServerException when the JSON response is missing the states field',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('initialization/states_missing.json'), 200));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tAuthenticationData),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should return a InitializationData',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('initialization/valid.json'), 200));
      // act
      final result = await remoteDataSource.fetchInitialization(
          tAppConnection, tAuthenticationData);
      // assert
      expect(result, equals(tInitializationData));
    },
  );
}
