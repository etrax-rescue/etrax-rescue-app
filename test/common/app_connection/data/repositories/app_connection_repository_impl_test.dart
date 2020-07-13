import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/common/app_connection/data/models/app_connection_model.dart';
import 'package:etrax_rescue_app/common/app_connection/data/repositories/app_connection_repository_impl.dart';
import 'package:etrax_rescue_app/common/app_connection/data/datasources/app_connection_local_datasource.dart';
import 'package:etrax_rescue_app/common/app_connection/data/datasources/app_connection_remote_endpoint_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';

class MockRemoteEndpointVerification extends Mock
    implements AppConnectionRemoteEndpointVerification {}

class MockLocalDataSource extends Mock implements AppConnectionLocalDataSource {
}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  AppConnectionRepositoryImpl repository;
  MockRemoteEndpointVerification mockRemoteEndpointVerification;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteEndpointVerification = MockRemoteEndpointVerification();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = AppConnectionRepositoryImpl(
      remoteEndpointVerification: mockRemoteEndpointVerification,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tBaseUri = 'https://www.etrax.at/';

  group('verifyAndStoreBaseUri', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.verifyAndStoreAppConnection(tBaseUri);
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
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          expect(result, equals(Left(NetworkFailure())));
        },
      );
    });

    testOnline(() {
      test(
        'should call the RemoteEndpointVerification when the device is online',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenAnswer((_) async => true);
          // act
          await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          verify(mockRemoteEndpointVerification.verifyRemoteEndpoint(tBaseUri));
          verifyNoMoreInteractions(mockRemoteEndpointVerification);
        },
      );
      test(
        'should return ServerFailure when the device is online and remote endpoint verification fails',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          verify(mockRemoteEndpointVerification.verifyRemoteEndpoint(tBaseUri));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          verify(mockRemoteEndpointVerification.verifyRemoteEndpoint(tBaseUri));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          verify(mockRemoteEndpointVerification.verifyRemoteEndpoint(tBaseUri));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should cache the uri when the device is online and remote endpoint verification succeeds',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenAnswer((_) async => true);
          // act
          await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          verify(mockLocalDataSource.cacheAppConnection(tBaseUri));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return None when the device is online and remote endpoint verification succeeds',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenAnswer((_) async => true);
          // act
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          expect(result, equals(Right(None())));
        },
      );
      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteEndpointVerification.verifyRemoteEndpoint(any))
              .thenAnswer((_) async => true);
          when(mockLocalDataSource.cacheAppConnection(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.verifyAndStoreAppConnection(tBaseUri);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getBaseUri', () {
    final tBaseUriModel = AppConnectionModel(baseUri: tBaseUri);
    test(
      'should ask local datasource for cached data',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAppConnection())
            .thenAnswer((_) async => tBaseUriModel);
        // act
        await repository.getAppConnection();
        // assert
        verify(mockLocalDataSource.getCachedAppConnection());
      },
    );
    test(
      'should return cached AppConnection',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAppConnection())
            .thenAnswer((_) async => tBaseUriModel);
        // act
        final result = await repository.getAppConnection();
        // assert
        expect(result, Right(tBaseUriModel));
      },
    );
    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAppConnection())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAppConnection();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });
}