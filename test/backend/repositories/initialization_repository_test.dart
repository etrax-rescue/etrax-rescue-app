import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/core/error/failures.dart';
import '../../../../lib/core/network/network_info.dart';
import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/backend/types/authentication_data.dart';
import '../../../../lib/backend/data/datasources/remote_initialization_data_source.dart';
import '../../../../lib/backend/data/datasources/local_user_states_data_source.dart';
import '../../../../lib/backend/data/datasources/local_user_roles_data_source.dart';
import '../../../../lib/backend/data/datasources/local_missions_data_source.dart';
import '../../../../lib/backend/data/datasources/local_app_settings_data_source.dart';
import '../../../../lib/backend/types/initialization_data.dart';
import '../../../../lib/backend/types/user_roles.dart';
import '../../../../lib/backend/types/user_states.dart';
import '../../../../lib/backend/types/app_configuration.dart';
import '../../../../lib/backend/types/missions.dart';
import '../../../../lib/backend/data/repositories/initialization_repository_impl.dart';

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

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';
  final tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppConfiguration = AppConfiguration(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

  final tMissionID = 42;
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tLatitude = 48.2206635;
  final tLongitude = 16.309849;
  final tMission = Mission(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollection = MissionCollection(missions: <Mission>[tMission]);

  final tID = 42;
  final tName = 'approaching';
  final tDescription = 'is on its way';
  final tLocationAccuracy = 2;
  final tUserState = UserState(
      id: tID,
      name: tName,
      description: tDescription,
      locationAccuracy: tLocationAccuracy);
  final tUserStateCollection =
      UserStateCollection(states: <UserState>[tUserState]);

  final tUserRole = UserRole(id: tID, name: tName, description: tDescription);
  final tUserRoleCollection = UserRoleCollection(roles: <UserRole>[tUserRole]);

  final tInitializationData = InitializationData(
    appConfiguration: tAppConfiguration,
    missionCollection: tMissionCollection,
    userStateCollection: tUserStateCollection,
    userRoleCollection: tUserRoleCollection,
  );

  group('fetchInitializationData', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        await repository.fetchInitializationData(
            tAppConnection, tAuthenticationData);
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
              tAppConnection, tAuthenticationData);
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
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          // act
          await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tAppConnection, tAuthenticationData));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tAppConnection, tAuthenticationData));
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
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tAppConnection, tAuthenticationData));
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
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tAppConnection, tAuthenticationData));
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
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenThrow(AuthenticationException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteDataSource.fetchInitialization(
              tAppConnection, tAuthenticationData));
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
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          // act
          await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockLocalAppSettingsDataSource
              .storeAppConfiguration(tInitializationData.appConfiguration));
          verify(mockLocalUserStatesDataSource
              .storeUserStates(tInitializationData.userStateCollection));
          verify(mockLocalUserRolesDataSource
              .storeUserRoles(tInitializationData.userRoleCollection));
          verify(mockLocalMissionsDataSource
              .insertMissions(tInitializationData.missionCollection));
        },
      );

      test(
        'should return CacheFailure when caching AppSettings fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          when(mockLocalAppSettingsDataSource.storeAppConfiguration(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching UserStates fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          when(mockLocalUserStatesDataSource.storeUserStates(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching UserRoles fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          when(mockLocalUserRolesDataSource.storeUserRoles(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return CacheFailure when caching Missions fails',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          when(mockLocalMissionsDataSource.insertMissions(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should return InitializationData if all operations succeed',
        () async {
          // arrange
          when(mockRemoteDataSource.fetchInitialization(any, any))
              .thenAnswer((_) async => tInitializationData);
          // act
          final result = await repository.fetchInitializationData(
              tAppConnection, tAuthenticationData);
          // assert
          expect(result, equals(Right(tInitializationData)));
        },
      );
    });
  });

  group('getAppConfiguration', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppConfiguration())
            .thenAnswer((_) async => tAppConfiguration);
        // act
        await repository.getAppConfiguration();
        // assert
        verify(mockLocalAppSettingsDataSource.getAppConfiguration());
      },
    );

    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppConfiguration())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAppConfiguration();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return cached AppSettings',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.getAppConfiguration())
            .thenAnswer((_) async => tAppConfiguration);
        // act
        final result = await repository.getAppConfiguration();
        // assert
        expect(result, equals(Right(tAppConfiguration)));
      },
    );
  });

  group('clearAppSettings', () {
    test(
      'should ask local data source to clear data',
      () async {
        // act
        await repository.clearAppConfiguration();
        // assert
        verify(mockLocalAppSettingsDataSource.clearAppConfiguration());
      },
    );

    test(
      'should return CacheFailure when clearing cached data fails',
      () async {
        // arrange
        when(mockLocalAppSettingsDataSource.clearAppConfiguration())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearAppConfiguration();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );

    test(
      'should return None when data was cleared successfully',
      () async {
        // act
        final result = await repository.clearAppConfiguration();
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
            .thenAnswer((_) async => tUserStateCollection);
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
      'should return cached UserStates',
      () async {
        // arrange
        when(mockLocalUserStatesDataSource.getUserStates())
            .thenAnswer((_) async => tUserStateCollection);
        // act
        final result = await repository.getUserStates();
        // assert
        expect(result, equals(Right(tUserStateCollection)));
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
            .thenAnswer((_) async => tUserRoleCollection);
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
      'should return cached UserRoles',
      () async {
        // arrange
        when(mockLocalUserRolesDataSource.getUserRoles())
            .thenAnswer((_) async => tUserRoleCollection);
        // act
        final result = await repository.getUserRoles();
        // assert
        expect(result, equals(Right(tUserRoleCollection)));
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
            .thenAnswer((_) async => tMissionCollection);
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
      'should return cached Missions',
      () async {
        // arrange
        when(mockLocalMissionsDataSource.getMissions())
            .thenAnswer((_) async => tMissionCollection);
        // act
        final result = await repository.getMissions();
        // assert
        expect(result, equals(Right(tMissionCollection)));
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
