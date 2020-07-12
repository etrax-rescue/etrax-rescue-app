import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_missions_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_app_settings_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/initialization_data_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/repositories/initialization_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteInitializationDataSource extends Mock
    implements RemoteInitializationDataSource {}

class MockLocalUserStatesDataSource extends Mock
    implements LocalUserStatesDataSource {}

class MockLocalMissionsDataSource extends Mock
    implements LocalMissionsDataSource {}

class MockLocalAppSettingsDataSource extends Mock
    implements LocalAppSettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteInitializationDataSource mockRemoteDataSource;
  MockLocalUserStatesDataSource mockLocalUserStatesDataSource;
  MockLocalMissionsDataSource mockLocalMissionsDataSource;
  MockLocalAppSettingsDataSource mockLocalAppSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;
  InitializationRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteInitializationDataSource();
    mockLocalUserStatesDataSource = MockLocalUserStatesDataSource();
    mockLocalMissionsDataSource = MockLocalMissionsDataSource();
    mockLocalAppSettingsDataSource = MockLocalAppSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = InitializationRepositoryImpl(
        remoteInitializationDataSource: mockRemoteDataSource,
        localUserStatesDataSource: mockLocalUserStatesDataSource,
        localAppSettingsDataSource: mockLocalAppSettingsDataSource,
        localMissionsDataSource: mockLocalMissionsDataSource,
        networkInfo: mockNetworkInfo);
  });

  String tBaseUri = 'https://etrax.at/appdata';
  String tUsername = 'JohnDoe';
  String tToken = '0123456789ABCDEF';

  group('fetchInitializationData', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        await repository.fetchInitializationData(tBaseUri, tUsername, tToken);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    void testOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      });
    }

    void testOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });
        body();
      });
    }

    testOffline(() {
      test(
        'should return a NetworkFailure when the device is offline',
        () async {
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Left(NetworkFailure())));
        },
      );
    });

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
    final tMissionsModel =
        MissionsModel(missions: <MissionModel>[tMissionModel]);

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

    testOnline(() {
      test(
        'should call the RemoteInitializationDataSource when the device is online',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          // act
          await repository.fetchInitializationData(tBaseUri, tUsername, tToken);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tBaseUri, tUsername, tToken));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}
