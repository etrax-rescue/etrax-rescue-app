import 'dart:convert';

import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/initialization_data_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteInitializationDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteInitializationDataSourceImpl(mockedHttpClient);
  });

  final tBaseUri = 'https://etrax.at/appdata';
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';

  final tLocationUpdateInterval = 0;
  final tAppSettingsModel =
      AppSettingsModel(locationUpdateInterval: tLocationUpdateInterval);

  final tMissionID = '0123456789ABCDEF';
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tLatitude = 48.2206635;
  final tLongitude = 16.309849;
  final tMissionModel = MissionModel(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionsModel = MissionsModel(missions: <MissionModel>[tMissionModel]);

  final tID = 42;
  final tName = 'approaching';
  final tDescription = 'is on its way';
  final tUserStateModel =
      UserStateModel(id: tID, name: tName, description: tDescription);
  final tUserStatesModel =
      UserStatesModel(states: <UserStateModel>[tUserStateModel]);

  final tUserRoleModel =
      UserRoleModel(id: tID, name: tName, description: tDescription);
  final tUserRolesModel =
      UserRolesModel(roles: <UserRoleModel>[tUserRoleModel]);

  final tInitializationDataModel = InitializationDataModel(
    appSettingsModel: tAppSettingsModel,
    missionsModel: tMissionsModel,
    userStatesModel: tUserStatesModel,
    userRolesModel: tUserRolesModel,
  );

  test(
    'should perform a GET request on the /initialization.php endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('initialization_full.json'), 200));
      final uri = Uri.https(tBaseUri, '/initialization.php');
      print(uri.toString());
      // act
      await remoteDataSource.fetchInitialization(tBaseUri, tUsername, tToken);
      // assert
      verify(mockedHttpClient.get(tBaseUri + '/initialization.php'));
    },
  );
}
