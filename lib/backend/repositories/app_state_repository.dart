import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_app_connection_data_source.dart';
import '../datasources/local/local_app_state_data_source.dart';
import '../datasources/local/local_authentication_data_source.dart';
import '../datasources/local/local_organizations_data_source.dart';
import '../datasources/remote/remote_app_connection_data_source.dart';
import '../datasources/remote/remote_login_data_source.dart';
import '../datasources/remote/remote_organizations_data_source.dart';
import '../types/app_connection.dart';
import '../types/app_state.dart';
import '../types/authentication_data.dart';
import '../types/missions.dart';
import '../types/organizations.dart';
import '../types/user_roles.dart';
import '../types/user_states.dart';

abstract class AppStateRepository {
  Future<Either<Failure, AppState>> getAppState();

  // AppConnection
  Future<Either<Failure, None>> setAppConnection(
      String authority, String basePath);
  Future<Either<Failure, AppConnection>> getAppConnection();
  Future<Either<Failure, None>> deleteAppConnection();

  // Login
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password);

  // Authentication
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
  Future<Either<Failure, None>> deleteAuthenticationData();

  // Organizations
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection);

  // Selected Mission
  Future<Either<Failure, None>> setSelectedMission(Mission mission);
  Future<Either<Failure, Mission>> getSelectedMission();

  // Selected UserState
  Future<Either<Failure, None>> setSelectedUserState(UserState state);
  Future<Either<Failure, UserState>> getSelectedUserState();

  // Selected UserRole
  Future<Either<Failure, None>> setSelectedUserRole(UserRole role);
  Future<Either<Failure, UserRole>> getSelectedUserRole();

  // Clean Selected Mission, UserState and UserRole
  Future<Either<Failure, None>> clearMissionData();

  // Username
  Future<Either<Failure, None>> setUsername();
  Future<Either<Failure, None>> getUsername();

  // Last Login Time
  Future<Either<Failure, None>> setLastLogin(DateTime lastLogin);
  Future<Either<Failure, DateTime>> getLastLogin();
}

class AppStateRepositoryImpl implements AppStateRepository {
  final LocalAppStateDataSource localAppStateDataSource;
  final RemoteAppConnectionDataSource remoteAppConnectionDataSource;
  final LocalAppConnectionDataSource localAppConnectionDataSource;
  final RemoteOrganizationsDataSource remoteOrganizationsDataSource;
  final LocalOrganizationsDataSource localOrganizationsDataSource;
  final RemoteLoginDataSource remoteLoginDataSource;
  final LocalAuthenticationDataSource localAuthenticationDataSource;
  final NetworkInfo networkInfo;

  AppStateRepositoryImpl({
    @required this.localAppStateDataSource,
    @required this.remoteAppConnectionDataSource,
    @required this.remoteOrganizationsDataSource,
    @required this.localOrganizationsDataSource,
    @required this.localAppConnectionDataSource,
    @required this.remoteLoginDataSource,
    @required this.localAuthenticationDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, AppState>> getAppState() {
    // TODO: implement getAppState
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AppConnection>> getAppConnection() async {
    try {
      final cachedAppConnection =
          await localAppConnectionDataSource.getCachedAppConnection();
      return Right(cachedAppConnection);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> setAppConnection(
      String authority, String basePath) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AppConnection model;
    try {
      model = await remoteAppConnectionDataSource.verifyRemoteEndpoint(
          authority, basePath);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on HandshakeException {
      return Left(ServerFailure());
    } on Exception {
      // TODO: handle empty header error!
      return Left(ServerFailure());
    }
    try {
      localAppConnectionDataSource.cacheAppConnection(model);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> deleteAppConnection() {
    // TODO: implement deleteAppConnection
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection) async {
    OrganizationCollection model;
    if (await networkInfo.isConnected) {
      bool failed = false;
      try {
        model =
            await remoteOrganizationsDataSource.getOrganizations(appConnection);
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      }
      if (failed == true) {
        try {
          model = await localOrganizationsDataSource.getCachedOrganizations();
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      } else {
        try {
          await localOrganizationsDataSource.cacheOrganizations(model);
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      }
    } else {
      try {
        model = await localOrganizationsDataSource.getCachedOrganizations();
      } on CacheException {
        return Left(CacheFailure());
      }
      return Right(model);
    }
  }

  @override
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AuthenticationData authenticationDataModel;
    try {
      authenticationDataModel = await remoteLoginDataSource.login(
          appConnection, organizationID, username, password);
    } on ServerException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on LoginException {
      return Left(LoginFailure());
    }
    try {
      localAuthenticationDataSource
          .cacheAuthenticationData(authenticationDataModel);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    AuthenticationData data;
    try {
      data = await localAuthenticationDataSource.getCachedAuthenticationData();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> deleteAuthenticationData() {
    // TODO: implement deleteAuthenticationData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> clearMissionData() {
    // TODO: implement clearMissionData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DateTime>> getLastLogin() {
    // TODO: implement getLastLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Mission>> getSelectedMission() {
    // TODO: implement getSelectedMission
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserRole>> getSelectedUserRole() {
    // TODO: implement getSelectedUserRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserState>> getSelectedUserState() {
    // TODO: implement getSelectedUserState
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> getUsername() {
    // TODO: implement getUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> setLastLogin(DateTime lastLogin) {
    // TODO: implement setLastLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> setSelectedMission(Mission mission) {
    // TODO: implement setSelectedMission
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> setSelectedUserRole(UserRole role) {
    // TODO: implement setSelectedUserRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> setSelectedUserState(UserState state) {
    // TODO: implement setSelectedUserState
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> setUsername() {
    // TODO: implement setUsername
    throw UnimplementedError();
  }
}
