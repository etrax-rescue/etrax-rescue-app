import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/types/mission_state.dart';
import 'package:flutter/material.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_app_connection_data_source.dart';
import '../datasources/local/local_login_data_source.dart';
import '../datasources/local/local_mission_state_data_source.dart';
import '../datasources/local/local_organizations_data_source.dart';
import '../datasources/remote/remote_app_connection_data_source.dart';
import '../datasources/remote/remote_login_data_source.dart';
import '../datasources/remote/remote_organizations_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/missions.dart';
import '../types/organizations.dart';
import '../types/user_roles.dart';
import '../types/user_states.dart';

abstract class AppStateRepository {
  // AppConnection
  Future<Either<Failure, None>> setAppConnection(
      String authority, String basePath);
  Future<Either<Failure, AppConnection>> getAppConnection();
  Future<Either<Failure, None>> deleteAppConnection();

  // Login and logout
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password);
  Future<Either<Failure, None>> logout();

  // Authentication
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();

  // Organizations
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection);

  // Selected Mission
  Future<Either<Failure, None>> setSelectedMission(Mission mission);

  // Selected UserState
  Future<Either<Failure, None>> setSelectedUserState(UserState state);

  // Selected UserRole
  Future<Either<Failure, None>> setSelectedUserRole(UserRole role);

  Future<Either<Failure, MissionState>> getMissionState();
}

class AppStateRepositoryImpl implements AppStateRepository {
  final RemoteAppConnectionDataSource remoteAppConnectionDataSource;
  final LocalAppConnectionDataSource localAppConnectionDataSource;

  final RemoteOrganizationsDataSource remoteOrganizationsDataSource;
  final LocalOrganizationsDataSource localOrganizationsDataSource;

  final RemoteLoginDataSource remoteLoginDataSource;
  final LocalLoginDataSource localLoginDataSource;

  final LocalMissionStateDataSource localMissionStateDataSource;

  final NetworkInfo networkInfo;

  AppStateRepositoryImpl({
    @required this.remoteAppConnectionDataSource,
    @required this.localAppConnectionDataSource,
    @required this.remoteOrganizationsDataSource,
    @required this.localOrganizationsDataSource,
    @required this.remoteLoginDataSource,
    @required this.localLoginDataSource,
    @required this.localMissionStateDataSource,
    @required this.networkInfo,
  });

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
      await localAppConnectionDataSource.cacheAppConnection(model);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> deleteAppConnection() async {
    try {
      localAppConnectionDataSource.deleteAppConnection();
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
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
      await localLoginDataSource
          .cacheSelectedOrganizationID(authenticationDataModel.organizationID);
      await localLoginDataSource
          .cacheUsername(authenticationDataModel.username);
      await localLoginDataSource.cacheToken(authenticationDataModel.token);
      await localLoginDataSource
          .cacheIssuingDate(authenticationDataModel.issuingDate);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> logout() async {
    try {
      await localLoginDataSource.deleteToken();
      await localMissionStateDataSource.clear();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    AuthenticationData data;
    String username;
    String organizationID;
    String token;
    DateTime issuingDate;
    try {
      username = await localLoginDataSource.getCachedUsername();
      organizationID =
          await localLoginDataSource.getCachedSelectedOrganizationID();
      token = await localLoginDataSource.getCachedToken();
      issuingDate = await localLoginDataSource.getCachedIssuingDate();
    } on CacheException {
      return Left(CacheFailure());
    }
    data = AuthenticationData(
      organizationID: organizationID,
      username: username,
      token: token,
      issuingDate: issuingDate,
    );
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> setSelectedUserRole(UserRole role) async {
    try {
      await localMissionStateDataSource.cacheSelectedUserRole(role);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> setSelectedUserState(UserState state) async {
    try {
      await localMissionStateDataSource.cacheSelectedUserState(state);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> setSelectedMission(Mission mission) async {
    try {
      await localMissionStateDataSource.cacheSelectedMission(mission);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, MissionState>> getMissionState() async {
    Mission mission;
    UserState state;
    UserRole role;
    try {
      mission = await localMissionStateDataSource.getCachedSelectedMission();
      state = await localMissionStateDataSource.getCachedSelectedUserState();
      role = await localMissionStateDataSource.getCachedSelectedUserRole();
      return Right(MissionState(mission: mission, state: state, role: role));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
