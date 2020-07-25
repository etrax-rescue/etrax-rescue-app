import 'dart:convert';
import 'dart:io';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/initialization_data_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteInitializationDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteInitializationDataSourceImpl(mockedHttpClient);
  });

  // AppConnection
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  // Authorization
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';

  // AppSettings
  final tLocationUpdateInterval = 60;
  final tAppSettingsModel =
      AppSettingsModel(locationUpdateInterval: tLocationUpdateInterval);

  // MissionCollection
  final tMissionID = 42;
  final tMissionName = 'Wien';
  final tMissionStart = DateTime.utc(2020, 2, 2, 20, 20, 2, 20);
  final tLatitude = 48.2084114;
  final tLongitude = 16.3712767;
  final tMissionModel = MissionModel(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollectionModel =
      MissionCollectionModel(missions: <MissionModel>[tMissionModel]);

  // UserStateCollection
  final tUserStateID = 42;
  final tUserStateName = 'approaching';
  final tUserStateDescription = 'is on their way';
  final tUserStateModel = UserStateModel(
      id: tUserStateID,
      name: tUserStateName,
      description: tUserStateDescription);
  final tUserStateCollectionModel =
      UserStateCollectionModel(states: <UserStateModel>[tUserStateModel]);

  // UserRoleCollection
  final tUserRoleID = 42;
  final tUserRoleName = 'operator';
  final tUserRoleDescription = 'the one who does stuff';
  final tUserRoleModel = UserRoleModel(
      id: tUserRoleID, name: tUserRoleName, description: tUserRoleDescription);
  final tUserRoleCollectionModel =
      UserRoleCollectionModel(roles: <UserRoleModel>[tUserRoleModel]);

  // InitializationDataModel
  final tInitializationDataModel = InitializationDataModel(
    appSettingsModel: tAppSettingsModel,
    missionCollectionModel: tMissionCollectionModel,
    userStateCollectionModel: tUserStateCollectionModel,
    userRoleCollectionModel: tUserRoleCollectionModel,
  );

  test(
    'should perform a GET request on the /initialization.php endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('initialization/valid.json'), 200));
      final uri = tAppConnection.generateUri(
          subPath: EtraxServerEndpoints.initialization);
      final authString = base64.encode(utf8.encode('$tUsername:$tToken'));
      // act
      await remoteDataSource.fetchInitialization(
          tAppConnection, tUsername, tToken);
      // assert
      verify(mockedHttpClient.get(uri,
          headers: {HttpHeaders.authorizationHeader: 'Basic $authString'}));
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
      expect(() => call(tAppConnection, tUsername, tToken),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw an AuthenticationException when the server responds with code 403',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 403));
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tUsername, tToken),
          throwsA(TypeMatcher<AuthenticationException>()));
    },
  );

  test(
    'should throw a ServerException when the JSON response is missing the appSettings field',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('initialization/app_settings_missing.json'), 200));
      // act
      final call = remoteDataSource.fetchInitialization;
      // assert
      expect(() => call(tAppConnection, tUsername, tToken),
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
      expect(() => call(tAppConnection, tUsername, tToken),
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
      expect(() => call(tAppConnection, tUsername, tToken),
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
      expect(() => call(tAppConnection, tUsername, tToken),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should return a InitializationDataModel',
    () async {
      // arrange
      when(mockedHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('initialization/valid.json'), 200));
      // act
      final result = await remoteDataSource.fetchInitialization(
          tAppConnection, tUsername, tToken);
      // assert
      expect(result, equals(tInitializationDataModel));
    },
  );
}
