import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/backend/data/datasources/local_authentication_data_source.dart';
import 'package:etrax_rescue_app/backend/data/datasources/remote_login_data_source.dart';
import 'package:etrax_rescue_app/backend/data/models/authentication_data_model.dart';
import 'package:etrax_rescue_app/backend/data/models/organizations_model.dart';
import 'package:etrax_rescue_app/backend/data/repositories/authentication_repository_impl.dart';
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

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tToken = tPassword;

  final tAuthenticationDataModel = AuthenticationDataModel(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tName = 'Rettungshunde';
  final tOrganizationModel =
      OrganizationModel(id: tOrganizationID, name: tName);
  final tOrganizationCollectionModel = OrganizationCollectionModel(
      organizations: <OrganizationModel>[tOrganizationModel]);

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

  group('login', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        await repository.login(
            tAppConnection, tOrganizationID, tUsername, tPassword);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    testOffline(() {
      test(
        'should return a NetworkFailure when the device is offline',
        () async {
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
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
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );
      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return LoginFailure when a LoginException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenThrow(LoginException());
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(LoginFailure())));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should cache the token when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
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
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          expect(result, equals(Right(None())));
        },
      );

      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationDataModel);
          when(mockLocalDataSource.cacheAuthenticationData(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
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

  group('getOrganizations', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        await repository.getOrganizations(tAppConnection);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    testOffline(() {
      test(
        'should return cached data when it is present',
        () async {
          // arrange
          when(mockLocalDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          expect(result, equals(Right(tOrganizationCollectionModel)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getCachedOrganizations())
              .thenThrow(CacheException());
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCachedOrganizations());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });

    testOnline(() {
      test(
        'should call the remote data source when the device is online',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteDataSource.getOrganizations(tAppConnection));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return cached OrganizationCollectionModel when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenThrow(ServerException());
          when(mockLocalDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteDataSource.getOrganizations(tAppConnection));
          verify(mockLocalDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollectionModel)));
        },
      );

      test(
        'should return cached OrganizationCollectionModel when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenThrow(TimeoutException(''));
          when(mockLocalDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteDataSource.getOrganizations(tAppConnection));
          verify(mockLocalDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollectionModel)));
        },
      );

      test(
        'should return the cached OrganizationCollectionModel when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenThrow(SocketException(''));
          when(mockLocalDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteDataSource.getOrganizations(tAppConnection));
          verify(mockLocalDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollectionModel)));
        },
      );

      test(
        'should return CacheFailure when a Exception occurs during fetching of the remote data and a CacheException occurs when the cached content is accessed',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenThrow(ServerException());
          when(mockLocalDataSource.getCachedOrganizations())
              .thenThrow(CacheException());
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteDataSource.getOrganizations(tAppConnection));
          verify(mockLocalDataSource.getCachedOrganizations());
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should cache the organizations when the device is online and fetching of the data succeeds',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockLocalDataSource
              .cacheOrganizations(tOrganizationCollectionModel));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return OrganizationCollectionModel when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollectionModel);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          expect(result, equals(Right(tOrganizationCollectionModel)));
        },
      );

      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollectionModel);
          when(mockLocalDataSource.cacheOrganizations(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
