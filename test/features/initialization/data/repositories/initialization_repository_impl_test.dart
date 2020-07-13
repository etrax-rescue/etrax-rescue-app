import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_roles_data_source.dart';
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
import 'package:moor_flutter/moor_flutter.dart';

class MockRemoteInitializationDataSource extends Mock
    implements RemoteInitializationDataSource {}

class MockLocalUserStatesDataSource extends Mock
    implements LocalUserStatesDataSource {}

class MockLocalUserRolesDataSource extends Mock
    implements LocalUserRolesDataSource {}

class MockLocalMissionsDataSource extends Mock
    implements LocalMissionsDataSource {}

class MockLocalAppSettingsDataSource extends Mock
    implements LocalAppSettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteInitializationDataSource mockRemoteDataSource;
  MockLocalUserStatesDataSource mockLocalUserStatesDataSource;
  MockLocalUserRolesDataSource mockLocalUserRolesDataSource;
  MockLocalMissionsDataSource mockLocalMissionsDataSource;
  MockLocalAppSettingsDataSource mockLocalAppSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;
  InitializationRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteInitializationDataSource();
    mockLocalUserStatesDataSource = MockLocalUserStatesDataSource();
    mockLocalUserRolesDataSource = MockLocalUserRolesDataSource();
    mockLocalMissionsDataSource = MockLocalMissionsDataSource();
    mockLocalAppSettingsDataSource = MockLocalAppSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = InitializationRepositoryImpl(
        remoteInitializationDataSource: mockRemoteDataSource,
        localUserStatesDataSource: mockLocalUserStatesDataSource,
        localAppSettingsDataSource: mockLocalAppSettingsDataSource,
        localMissionsDataSource: mockLocalMissionsDataSource,
        localUserRolesDataSource: mockLocalUserRolesDataSource,
        networkInfo: mockNetworkInfo);
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

      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tBaseUri, tUsername, tToken));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppSettingsDataSource);
          verifyZeroInteractions(mockLocalMissionsDataSource);
          verifyZeroInteractions(mockLocalUserRolesDataSource);
          verifyZeroInteractions(mockLocalUserStatesDataSource);
        },
      );

      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tBaseUri, tUsername, tToken));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppSettingsDataSource);
          verifyZeroInteractions(mockLocalMissionsDataSource);
          verifyZeroInteractions(mockLocalUserRolesDataSource);
          verifyZeroInteractions(mockLocalUserStatesDataSource);
        },
      );

      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tBaseUri, tUsername, tToken));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppSettingsDataSource);
          verifyZeroInteractions(mockLocalMissionsDataSource);
          verifyZeroInteractions(mockLocalUserRolesDataSource);
          verifyZeroInteractions(mockLocalUserStatesDataSource);
        },
      );
      test(
        'should return AuthenticationFailure when a AuthenticationException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenThrow(AuthenticationException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tBaseUri, tUsername, tToken));
          expect(result, equals(Left(AuthenticationFailure())));
          verifyZeroInteractions(mockLocalAppSettingsDataSource);
          verifyZeroInteractions(mockLocalMissionsDataSource);
          verifyZeroInteractions(mockLocalUserRolesDataSource);
          verifyZeroInteractions(mockLocalUserStatesDataSource);
        },
      );

      test(
        'should cache the initialization data',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          // act
          await repository.fetchInitializationData(tBaseUri, tUsername, tToken);
          // assert
          verify(mockLocalAppSettingsDataSource
              .storeAppSettings(tInitializationDataModel.appSettingsModel));
          verify(mockLocalUserStatesDataSource
              .storeUserStates(tInitializationDataModel.userStatesModel));
          verify(mockLocalUserRolesDataSource
              .storeUserRoles(tInitializationDataModel.userRolesModel));
          verify(mockLocalMissionsDataSource
              .insertMissions(tInitializationDataModel.missionsModel));
        },
      );

      test(
        'should return CacheFailure when caching AppSettings fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          when(mockLocalAppSettingsDataSource.storeAppSettings(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching UserStates fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          when(mockLocalUserStatesDataSource.storeUserStates(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching UserRoles fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          when(mockLocalUserRolesDataSource.storeUserRoles(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching Missions fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          when(mockLocalMissionsDataSource.insertMissions(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return None if all operations succeed',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any, any))
              .thenAnswer((_) async => tInitializationDataModel);
          // act
          final result = await repository.fetchInitializationData(
              tBaseUri, tUsername, tToken);
          // assert
          expect(result, equals(Right(None())));
        },
      );
    });
  });

  group('getAppSettings', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppSettings())
            .thenAnswer((_) async => tAppSettingsModel);
        // act
        await repository.getAppSettings();
        // assert
        verify(mockLocalAppSettingsDataSource.getAppSettings());
      },
    );

    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppSettings())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAppSettings();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return cached AppSettingsModel',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppSettings())
            .thenAnswer((_) async => tAppSettingsModel);
        // act
        final result = await repository.getAppSettings();
        // assert
        expect(result, equals(Right(tAppSettingsModel)));
      },
    );
  });

  group('clearAppSettings', () {
    test(
      'should ask local data source to clear data',
      () async {
        // act
        await repository.clearAppSettings();
        // assert
        verify(mockLocalAppSettingsDataSource.clearAppSettings());
      },
    );

    test(
      'should return CacheFailure when clearing cached data fails',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.clearAppSettings())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearAppSettings();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return None when data was cleared successfully',
      () async {
        // act
        final result = await repository.clearAppSettings();
        // assert
        expect(result, equals(Right(None())));
      },
    );
  });

  group('getUserStates', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalUserStatesDataSource.getUserStates())
            .thenAnswer((_) async => tUserStatesModel);
        // act
        await repository.getUserStates();
        // assert
        verify(mockLocalUserStatesDataSource.getUserStates());
      },
    );

    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalUserStatesDataSource.getUserStates())
            .thenThrow(CacheException());
        // act
        final result = await repository.getUserStates();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return cached UserStatesModel',
      () async {
        // arrange
        when(mockLocalUserStatesDataSource.getUserStates())
            .thenAnswer((_) async => tUserStatesModel);
        // act
        final result = await repository.getUserStates();
        // assert
        expect(result, equals(Right(tUserStatesModel)));
      },
    );
  });

  group('clearUserStates', () {
    test(
      'should ask local data source to clear data',
      () async {
        // act
        await repository.clearUserStates();
        // assert
        verify(mockLocalUserStatesDataSource.clearUserStates());
      },
    );

    test(
      'should return CacheFailure when clearing cached data fails',
      () async {
        // arrange
        when(mockLocalUserStatesDataSource.clearUserStates())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearUserStates();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return None when data was cleared successfully',
      () async {
        // act
        final result = await repository.clearUserStates();
        // assert
        expect(result, equals(Right(None())));
      },
    );
  });

  group('getUserRoles', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalUserRolesDataSource.getUserRoles())
            .thenAnswer((_) async => tUserRolesModel);
        // act
        await repository.getUserRoles();
        // assert
        verify(mockLocalUserRolesDataSource.getUserRoles());
      },
    );

    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalUserRolesDataSource.getUserRoles())
            .thenThrow(CacheException());
        // act
        final result = await repository.getUserRoles();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return cached UserRolesModel',
      () async {
        // arrange
        when(mockLocalUserRolesDataSource.getUserRoles())
            .thenAnswer((_) async => tUserRolesModel);
        // act
        final result = await repository.getUserRoles();
        // assert
        expect(result, equals(Right(tUserRolesModel)));
      },
    );
  });

  group('clearUserStates', () {
    test(
      'should ask local data source to clear data',
      () async {
        // act
        await repository.clearUserRoles();
        // assert
        verify(mockLocalUserRolesDataSource.clearUserRoles());
      },
    );

    test(
      'should return CacheFailure when clearing cached data fails',
      () async {
        // arrange
        when(mockLocalUserRolesDataSource.clearUserRoles())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearUserRoles();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return None when data was cleared successfully',
      () async {
        // act
        final result = await repository.clearUserRoles();
        // assert
        expect(result, equals(Right(None())));
      },
    );
  });

  group('getMissions', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.getMissions())
            .thenAnswer((_) async => tMissionsModel);
        // act
        await repository.getMissions();
        // assert
        verify(mockLocalMissionsDataSource.getMissions());
      },
    );

    test(
      'should return CacheFailure when a CacheException occurs',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.getMissions())
            .thenThrow(CacheException());
        // act
        final result = await repository.getMissions();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return CacheFailure when a InvalidDataException occurs',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.getMissions())
            .thenThrow(InvalidDataException(''));
        // act
        final result = await repository.getMissions();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return cached MissionsModel',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.getMissions())
            .thenAnswer((_) async => tMissionsModel);
        // act
        final result = await repository.getMissions();
        // assert
        expect(result, equals(Right(tMissionsModel)));
      },
    );
  });

  group('clearMissions', () {
    test(
      'should ask local data source to clear data',
      () async {
        // act
        await repository.clearMissions();
        // assert
        verify(mockLocalMissionsDataSource.clearMissions());
      },
    );

    test(
      'should return CacheFailure when clearing cached data fails',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.clearMissions())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearMissions();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return None when data was cleared successfully',
      () async {
        // act
        final result = await repository.clearMissions();
        // assert
        expect(result, equals(Right(None())));
      },
    );
  });
}
