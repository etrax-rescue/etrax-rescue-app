import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_mission_state_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/types/organizations.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/repositories/mission_state_repository.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_app_connection_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_app_connection_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_login_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_organizations_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_organizations_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_login_data_source.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';

class MockLocalMissionStateDataSource extends Mock
    implements LocalMissionStateDataSource {}

class MockRemoteAppConnectionDataSource extends Mock
    implements RemoteAppConnectionDataSource {}

class MockLocalAppConnectionDataSource extends Mock
    implements LocalAppConnectionDataSource {}

class MockRemoteOrganizationsDataSource extends Mock
    implements RemoteOrganizationsDataSource {}

class MockLocalOrganizationsDataSource extends Mock
    implements LocalOrganizationsDataSource {}

class MockRemoteLoginDataSource extends Mock implements RemoteLoginDataSource {}

class MockLocalLoginDataSource extends Mock implements LocalLoginDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MissionStateRepository repository;
  MockLocalMissionStateDataSource mockLocalMissionStateDataSource;
  MockRemoteAppConnectionDataSource mockRemoteAppConnectionDataSource;
  MockLocalAppConnectionDataSource mockLocalAppConnectionDataSource;
  MockRemoteOrganizationsDataSource mockRemoteOrganizationsDataSource;
  MockLocalOrganizationsDataSource mockLocalOrganizationsDataSource;
  MockRemoteLoginDataSource mockRemoteLoginDataSource;
  MockLocalLoginDataSource mockLocalLoginDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalMissionStateDataSource = MockLocalMissionStateDataSource();
    mockRemoteAppConnectionDataSource = MockRemoteAppConnectionDataSource();
    mockLocalAppConnectionDataSource = MockLocalAppConnectionDataSource();
    mockRemoteOrganizationsDataSource = MockRemoteOrganizationsDataSource();
    mockLocalOrganizationsDataSource = MockLocalOrganizationsDataSource();
    mockRemoteLoginDataSource = MockRemoteLoginDataSource();
    mockLocalLoginDataSource = MockLocalLoginDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MissionStateRepositoryImpl(
      remoteAppConnectionDataSource: mockRemoteAppConnectionDataSource,
      localAppConnectionDataSource: mockLocalAppConnectionDataSource,
      networkInfo: mockNetworkInfo,
      localLoginDataSource: mockLocalLoginDataSource,
      localOrganizationsDataSource: mockLocalOrganizationsDataSource,
      remoteLoginDataSource: mockRemoteLoginDataSource,
      remoteOrganizationsDataSource: mockRemoteOrganizationsDataSource,
      localMissionStateDataSource: mockLocalMissionStateDataSource,
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

  final tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tName = 'Rettungshunde';
  final tOrganization = Organization(id: tOrganizationID, name: tName);
  final tOrganizationCollection =
      OrganizationCollection(organizations: <Organization>[tOrganization]);

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
        repository.setAppConnection(tAuthority, tBasePath);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    testOffline(() {
      test(
        'should return a NetworkFailure when the device is offline',
        () async {
          // act
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
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
          await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tAuthority, tBasePath));
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
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tAuthority, tBasePath));
          expect(result, equals(Left(ServerFailure())));
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
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tAuthority, tBasePath));
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
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tAuthority, tBasePath));
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
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockRemoteAppConnectionDataSource.verifyRemoteEndpoint(
              tAuthority, tBasePath));
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
          await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          verify(mockLocalAppConnectionDataSource
              .cacheAppConnection(tAppConnection));

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
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
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
          when(mockLocalAppConnectionDataSource.cacheAppConnection(any))
              .thenThrow(CacheException());
          // act
          final result =
              await repository.setAppConnection(tAuthority, tBasePath);
          // assert
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getAppConnection', () {
    final tAppConnection =
        AppConnection(authority: tAuthority, basePath: tBasePath);
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
        'should call the RemoteLoginDataSource when the device is online',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationData);
          // act
          await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteLoginDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
        },
      );

      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteLoginDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalLoginDataSource);
        },
      );

      test(
        'should return ServerFailure when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenThrow(TimeoutException(''));
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteLoginDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalLoginDataSource);
        },
      );
      test(
        'should return ServerFailure when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenThrow(SocketException(''));
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteLoginDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(ServerFailure())));
          verifyZeroInteractions(mockLocalLoginDataSource);
        },
      );

      test(
        'should return LoginFailure when a LoginException occurs',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenThrow(LoginException());
          // act
          final result = await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockRemoteLoginDataSource.login(
              tAppConnection, tOrganizationID, tUsername, tPassword));
          expect(result, equals(Left(LoginFailure())));
          verifyZeroInteractions(mockLocalLoginDataSource);
        },
      );

      test(
        'should cache the token when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationData);
          // act
          await repository.login(
              tAppConnection, tOrganizationID, tUsername, tPassword);
          // assert
          verify(mockLocalLoginDataSource
              .cacheAuthenticationData(tAuthenticationData));
          verifyNoMoreInteractions(mockLocalLoginDataSource);
        },
      );

      test(
        'should return None when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationData);
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
          when(mockRemoteLoginDataSource.login(any, any, any, any))
              .thenAnswer((_) async => tAuthenticationData);
          when(mockLocalLoginDataSource.cacheUsername(tUsername))
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
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          expect(result, equals(Right(tOrganizationCollection)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenThrow(CacheException());
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verifyZeroInteractions(mockRemoteOrganizationsDataSource);
          verify(mockLocalOrganizationsDataSource.getCachedOrganizations());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });

    testOnline(() {
      test(
        'should call the remote data source when the device is online',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteOrganizationsDataSource
              .getOrganizations(tAppConnection));
          verifyNoMoreInteractions(mockRemoteOrganizationsDataSource);
        },
      );

      test(
        'should return cached OrganizationCollection when a ServerException occurs',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenThrow(ServerException());
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteOrganizationsDataSource
              .getOrganizations(tAppConnection));
          verify(mockLocalOrganizationsDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollection)));
        },
      );

      test(
        'should return cached OrganizationCollection when a TimeoutException occurs',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenThrow(TimeoutException(''));
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteOrganizationsDataSource
              .getOrganizations(tAppConnection));
          verify(mockLocalOrganizationsDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollection)));
        },
      );

      test(
        'should return the cached OrganizationCollection when a SocketException occurs',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenThrow(SocketException(''));
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteOrganizationsDataSource
              .getOrganizations(tAppConnection));
          verify(mockLocalOrganizationsDataSource.getCachedOrganizations());
          expect(result, equals(Right(tOrganizationCollection)));
        },
      );

      test(
        'should return CacheFailure when a Exception occurs during fetching of the remote data and a CacheException occurs when the cached content is accessed',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenThrow(ServerException());
          when(mockLocalOrganizationsDataSource.getCachedOrganizations())
              .thenThrow(CacheException());
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockRemoteOrganizationsDataSource
              .getOrganizations(tAppConnection));
          verify(mockLocalOrganizationsDataSource.getCachedOrganizations());
          expect(result, equals(Left(CacheFailure())));
        },
      );

      test(
        'should cache the organizations when the device is online and fetching of the data succeeds',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          await repository.getOrganizations(tAppConnection);
          // assert
          verify(mockLocalOrganizationsDataSource
              .cacheOrganizations(tOrganizationCollection));
          verifyNoMoreInteractions(mockLocalOrganizationsDataSource);
        },
      );

      test(
        'should return OrganizationCollection when the device is online and login succeeds',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollection);
          // act
          final result = await repository.getOrganizations(tAppConnection);
          // assert
          expect(result, equals(Right(tOrganizationCollection)));
        },
      );

      test(
        'should return CacheFailure when caching fails',
        () async {
          // arrange
          when(mockRemoteOrganizationsDataSource.getOrganizations(any))
              .thenAnswer((_) async => tOrganizationCollection);
          when(mockLocalOrganizationsDataSource.cacheOrganizations(any))
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
