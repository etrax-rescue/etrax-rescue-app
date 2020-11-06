import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/repositories/mission_details_repository.dart';
import 'package:etrax_rescue_app/backend/types/mission_details.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/datasources/local/local_mission_details_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_mission_details_data_source.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';

import '../../reference_types.dart';

class MockLocalMissionDetailsDataSource extends Mock
    implements LocalMissionDetailsDataSource {}

class MockRemoteMissionDetailsDataSource extends Mock
    implements RemoteMissionDetailsDataSource {}

class MockCacheManager extends Mock implements DefaultCacheManager {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MissionDetailsRepository repository;
  MockLocalMissionDetailsDataSource mockLocalMissionDetailsDataSource;
  MockRemoteMissionDetailsDataSource mockRemoteMissionDetailsDataSource;
  MockCacheManager mockCacheManager;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalMissionDetailsDataSource = MockLocalMissionDetailsDataSource();
    mockRemoteMissionDetailsDataSource = MockRemoteMissionDetailsDataSource();
    mockCacheManager = MockCacheManager();
    mockNetworkInfo = MockNetworkInfo();

    repository = MissionDetailsRepositoryImpl(
      networkInfo: mockNetworkInfo,
      cacheManager: mockCacheManager,
      remoteDetailsDataSource: mockRemoteMissionDetailsDataSource,
      localMissionDetailsDataSource: mockLocalMissionDetailsDataSource,
    );
  });

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

  group('getMissionDetails', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMissionDetails(tAppConnection, tAuthenticationData);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    final tMissionDetailTextTitle = 'Description';
    final tMissionDetailTextBody = 'A smart dog';
    final tMissionDetailImageTitle = 'Dog';
    final tMissionDetailImageUID = 'WUFF';
    final tMissionDetailText = MissionDetailText(
        title: tMissionDetailTextTitle, body: tMissionDetailTextBody);
    final tMissionDetailImage = MissionDetailImage(
        title: tMissionDetailImageTitle, uid: tMissionDetailImageUID);

    testOnline(() {
      test(
        'should call remote datasource',
        () async {
          // arrange
          when(mockRemoteMissionDetailsDataSource.fetchMissionDetails(
                  tAppConnection, tAuthenticationData))
              .thenAnswer((_) async => MissionDetailCollection(
                  details: [tMissionDetailText, tMissionDetailImage]));
          // act
          await repository.getMissionDetails(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteMissionDetailsDataSource.fetchMissionDetails(
              tAppConnection, tAuthenticationData));
        },
      );

      test(
        'should cache the data after new data was fetched',
        () async {
          // arrange
          when(mockRemoteMissionDetailsDataSource.fetchMissionDetails(
                  tAppConnection, tAuthenticationData))
              .thenAnswer((_) async => MissionDetailCollection(
                  details: [tMissionDetailText, tMissionDetailImage]));
          // act
          await repository.getMissionDetails(
              tAppConnection, tAuthenticationData);
          // assert
          verify(mockRemoteMissionDetailsDataSource.fetchMissionDetails(
              tAppConnection, tAuthenticationData));
        },
      );
    });
  });

  group('clearMissionDetails', () {
    test(
      'should call the empty method of the cache manager',
      () async {
        // arrange
        when(mockCacheManager.emptyCache()).thenAnswer((_) async => null);
        when(mockLocalMissionDetailsDataSource.deleteCachedMissionDetails())
            .thenAnswer((_) async => null);
        // act
        await repository.clearMissionDetails();
        // assert
        verify(mockCacheManager.emptyCache());
      },
    );

    test(
      'should call the delete method of the local data source',
      () async {
        // arrange
        when(mockCacheManager.emptyCache()).thenAnswer((_) async => null);
        when(mockLocalMissionDetailsDataSource.deleteCachedMissionDetails())
            .thenAnswer((_) async => true);
        // act
        await repository.clearMissionDetails();
        // assert
        verify(mockCacheManager.emptyCache());
        verify(mockLocalMissionDetailsDataSource.deleteCachedMissionDetails());
      },
    );

    test(
      'should return None if the MissionDetails were cleared successfully',
      () async {
        // arrange
        when(mockCacheManager.emptyCache()).thenAnswer((_) async => null);
        when(mockLocalMissionDetailsDataSource.deleteCachedMissionDetails())
            .thenAnswer((_) async => true);
        // act
        final result = await repository.clearMissionDetails();
        // assert
        expect(result, Right(None()));
      },
    );

    test(
      'should return CacheFailure if clearing the cache failed',
      () async {
        // arrange
        when(mockCacheManager.emptyCache()).thenAnswer((_) async => null);
        when(mockLocalMissionDetailsDataSource.deleteCachedMissionDetails())
            .thenThrow(CacheException());
        // act
        final result = await repository.clearMissionDetails();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
