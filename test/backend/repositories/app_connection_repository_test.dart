import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_barcode_data_source.dart';
import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_app_connection_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_app_connection_data_source.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';

import '../../reference_types.dart';

class MockRemoteAppConnectionDataSource extends Mock
    implements RemoteAppConnectionDataSource {}

class MockLocalAppConnectionDataSource extends Mock
    implements LocalAppConnectionDataSource {}

class MockLocalBarcodeDataSource extends Mock
    implements LocalBarcodeDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  AppConnectionRepository repository;

  MockRemoteAppConnectionDataSource mockRemoteAppConnectionDataSource;
  MockLocalAppConnectionDataSource mockLocalAppConnectionDataSource;
  MockLocalBarcodeDataSource mockLocalBarcodeDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteAppConnectionDataSource = MockRemoteAppConnectionDataSource();
    mockLocalAppConnectionDataSource = MockLocalAppConnectionDataSource();
    mockLocalBarcodeDataSource = MockLocalBarcodeDataSource();

    mockNetworkInfo = MockNetworkInfo();

    repository = AppConnectionRepositoryImpl(
      localAppConnectionDataSource: mockLocalAppConnectionDataSource,
      localBarcodeDataSource: mockLocalBarcodeDataSource,
      networkInfo: mockNetworkInfo,
      remoteAppConnectionDataSource: mockRemoteAppConnectionDataSource,
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

  group('setAppConnection', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.setAppConnection(tHost, tBasePath);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    testOffline(() {
      test(
        'should return a NetworkFailure when the device is offline',
        () async {
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
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
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenAnswer((_) async => tAppConnection);
          // act
          await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tHost, tBasePath));
          verifyNoMoreInteractions(mockRemoteAppConnectionDataSource);
        },
      );

      test(
        'should return ServerFailure when the device is online and remote endpoint verification fails',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tHost, tBasePath));
          expect(result, equals(Left(ServerConnectionFailure())));
          verifyZeroInteractions(mockLocalAppConnectionDataSource);
        },
      );

      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tHost, tBasePath));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppConnectionDataSource);
        },
      );

      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tHost, tBasePath));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppConnectionDataSource);
        },
      );

      test(
        'should return ServerFailure when a HandshakeException occurs',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenThrow(HandshakeException(''));
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tHost, tBasePath));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalAppConnectionDataSource);
        },
      );

      test(
        'should cache the uri and set the update status to false when the device is online and remote endpoint verification succeeds',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenAnswer((_) async => tAppConnection);
          // act
          await repository.setAppConnection(tHost, tBasePath);
          // assert
          verify(mockLocalAppConnectionDataSource
              .setAppConnection(tAppConnection));

          verifyNoMoreInteractions(mockLocalAppConnectionDataSource);
        },
      );

      test(
        'should return None when the device is online and remote endpoint verification succeeds',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenAnswer((_) async => tAppConnection);
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          expect(result, equals(Right(None())));
        },
      );

      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(any, any))
              .thenAnswer((_) async => tAppConnection);
          when(mockLocalAppConnectionDataSource.setAppConnection(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.setAppConnection(tHost, tBasePath);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getAppConnection', () {
    final tAppConnection = AppConnection(host: tHost, basePath: tBasePath);
    test(
      'should ask local datasource for cached data',
      () async {
        // arrange
        when(mockLocalAppConnectionDataSource.getCachedAppConnection())
            .thenAnswer((_) async => tAppConnection);
        // act
        await repository.getAppConnection();
        // assert
        verify(mockLocalAppConnectionDataSource.getCachedAppConnection());
      },
    );
    test(
      'should return cached AppConnection',
      () async {
        // arrange
        when(mockLocalAppConnectionDataSource.getCachedAppConnection())
            .thenAnswer((_) async => tAppConnection);
        // act
        final result = await repository.getAppConnection();
        // assert
        expect(result, Right(tAppConnection));
      },
    );
    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalAppConnectionDataSource.getCachedAppConnection())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAppConnection();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('deleteAppConnection', () {
    test(
      'should call the local datasource to delete the app connection',
      () async {
        // act
        await repository.deleteAppConnection();
        // assert
        verify(mockLocalAppConnectionDataSource.deleteAppConnection());
      },
    );
  });
}
