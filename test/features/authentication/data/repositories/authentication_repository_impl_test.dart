import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/entities/app_connection.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/local_authentication_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/remote_login_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:etrax_rescue_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLocalAuthenticationDataSource extends Mock
    implements LocalAuthenticationDataSource {}

class MockRemoteLoginDataSource extends Mock implements RemoteLoginDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteLoginDataSource mockRemoteDataSource;
  MockLocalAuthenticationDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  AuthenticationRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockLocalAuthenticationDataSource();
    mockRemoteDataSource = MockRemoteLoginDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      localAuthenticationDataSource: mockLocalDataSource,
      remoteLoginDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);
  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tToken = tPassword;

  AuthenticationDataModel tAuthenticationDataModel =
      AuthenticationDataModel(username: tUsername, token: tToken);

  group('login', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        await repository.login(tAppConnection, tUsername, tPassword);
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
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
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
          when(mockRemoteDataSource.login(any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(
              mockRemoteDataSource.login(tAppConnection, tUsername, tPassword));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenThrow(ServerException());
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(
              mockRemoteDataSource.login(tAppConnection, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(
              mockRemoteDataSource.login(tAppConnection, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenThrow(SocketException(''));
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(
              mockRemoteDataSource.login(tAppConnection, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return LoginFailure when a LoginException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenThrow(LoginException());
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(
              mockRemoteDataSource.login(tAppConnection, tUsername, tPassword));
          expect(result, equals(Left(LoginFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should cache the token when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          verify(mockLocalDataSource
              .cacheAuthenticationData(tAuthenticationDataModel));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return None when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          expect(result, equals(Right(None())));
        },
      );

      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          when(mockLocalDataSource.cacheAuthenticationData(any))
              .thenThrow(CacheException());
          // act
          final result =
              await repository.login(tAppConnection, tUsername, tPassword);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getAuthenticationData', () {
    test(
      'should ask local data source for cached data',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAuthenticationData())
            .thenAnswer((_) async => tAuthenticationDataModel);
        // act
        await repository.getAuthenticationData();
        // assert
        verify(mockLocalDataSource.getCachedAuthenticationData());
      },
    );
    test(
      'should return cached AuthenticationDataModel',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAuthenticationData())
            .thenAnswer((_) async => tAuthenticationDataModel);
        // act
        final result = await repository.getAuthenticationData();
        // assert
        expect(result, equals(Right(tAuthenticationDataModel)));
      },
    );
    test(
      'should return CacheFailure when retrieving cached data fails',
      () async {
        // arrange
        when(mockLocalDataSource.getCachedAuthenticationData())
            .thenThrow(CacheException());
        // act
        final result = await repository.getAuthenticationData();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('deleteAuthenticationData', () {
    test(
      'should ask local data source to delete the authentication data',
      () async {
        // arrange
        when(mockLocalDataSource.deleteAuthenticationData())
            .thenAnswer((_) async => true);
        // act
        await repository.deleteAuthenticationData();
        // assert
        verify(mockLocalDataSource.deleteAuthenticationData());
      },
    );
  });
}
