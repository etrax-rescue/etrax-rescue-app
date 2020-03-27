import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/platform/network_info.dart';
import 'package:etrax_rescue_app/features/person/data/datasources/person_info_local_data_source.dart';
import 'package:etrax_rescue_app/features/person/data/datasources/person_info_remote_data_source.dart';
import 'package:etrax_rescue_app/features/person/data/models/person_info_model.dart';
import 'package:etrax_rescue_app/features/person/data/repositories/person_info_repository.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements PersonInfoRemoteDataSource {}

class MockLocalDataSource extends Mock implements PersonInfoLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  PersonInfoRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PersonInfoRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getPersonInfo', () {
    final String tUrl = "https://etrax.at/person";
    final String tToken = "0123456789ABCDEF";
    final tPersonInfoModel = PersonInfoModel(
        name: "John Doe",
        lastSeen: DateTime.parse("2020-02-02"),
        description: "Very Average Person");
    final PersonInfo tPersonInfo = tPersonInfoModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getPersonInfo(tUrl, tToken);
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

    testOnline(() {
      test(
        'should return remote data when the call to the remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getPersonInfo(any, any))
              .thenAnswer((_) async => tPersonInfoModel);
          // act
          final result = await repository.getPersonInfo(tUrl, tToken);
          // assert
          verify(mockRemoteDataSource.getPersonInfo(tUrl, tToken));
          expect(result, equals(Right(tPersonInfo)));
        },
      );

      test(
        'should cache the data locally when the call to the remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getPersonInfo(any, any))
              .thenAnswer((_) async => tPersonInfoModel);
          // act
          await repository.getPersonInfo(tUrl, tToken);
          // assert
          verify(mockRemoteDataSource.getPersonInfo(tUrl, tToken));
          verify(mockLocalDataSource.cachePersonInfo(tPersonInfoModel));
        },
      );

      test(
        'should return ServerFailure when the call to the remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getPersonInfo(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getPersonInfo(tUrl, tToken);
          // assert
          verify(mockRemoteDataSource.getPersonInfo(tUrl, tToken));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
    });

    testOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getCachedPersonInfo())
              .thenAnswer((_) async => tPersonInfoModel);
          // act
          final result = await repository.getPersonInfo(tUrl, tToken);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCachedPersonInfo());
          expect(result, equals(Right(tPersonInfo)));
        },
      );

      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getCachedPersonInfo())
              .thenThrow(CacheException());
          // act
          final result = await repository.getPersonInfo(tUrl, tToken);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCachedPersonInfo());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
