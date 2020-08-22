import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../domain/repositories/initialization_repository.dart';
import '../../types/app_configuration.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/initialization_data.dart';
import '../../types/missions.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';
import '../datasources/local_app_settings_data_source.dart';
import '../datasources/local_missions_data_source.dart';
import '../datasources/local_user_roles_data_source.dart';
import '../datasources/local_user_states_data_source.dart';
import '../datasources/remote_initialization_data_source.dart';

class InitializationRepositoryImpl implements InitializationRepository {
  final RemoteInitializationDataSource remoteInitializationDataSource;
  final LocalUserStatesDataSource localUserStatesDataSource;
  final LocalAppSettingsDataSource localAppSettingsDataSource;
  final LocalMissionsDataSource localMissionsDataSource;
  final LocalUserRolesDataSource localUserRolesDataSource;
  final NetworkInfo networkInfo;

  InitializationRepositoryImpl({
    @required this.remoteInitializationDataSource,
    @required this.localUserStatesDataSource,
    @required this.localAppSettingsDataSource,
    @required this.localMissionsDataSource,
    @required this.localUserRolesDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, InitializationData>> fetchInitializationData(
      AppConnection appConnection,
      AuthenticationData authenticationData) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    InitializationData initializationData;
    try {
      initializationData = await remoteInitializationDataSource
          .fetchInitialization(appConnection, authenticationData);
    } on ServerException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on FormatException {
      return Left(ServerFailure());
    } on AuthenticationException {
      return Left(AuthenticationFailure());
    } on HttpException {
      return Left(AuthenticationFailure());
    } on Exception {
      return Left(UnknownFailure());
    }

    try {
      localAppSettingsDataSource
          .storeAppConfiguration(initializationData.appConfiguration);

      localUserRolesDataSource
          .storeUserRoles(initializationData.userRoleCollection);

      localUserStatesDataSource
          .storeUserStates(initializationData.userStateCollection);

      localMissionsDataSource
          .insertMissions(initializationData.missionCollection);
    } on CacheException {
      return Left(CacheFailure());
    }

    return Right(initializationData);
  }

  @override
  Future<Either<Failure, AppConfiguration>> getAppConfiguration() async {
    AppConfiguration data;
    try {
      data = await localAppSettingsDataSource.getAppConfiguration();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearAppConfiguration() async {
    try {
      await localAppSettingsDataSource.clearAppConfiguration();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, MissionCollection>> getMissions() async {
    MissionCollection data;
    try {
      data = await localMissionsDataSource.getMissions();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearMissions() async {
    try {
      await localMissionsDataSource.clearMissions();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, UserStateCollection>> getUserStates() async {
    UserStateCollection data;
    try {
      data = await localUserStatesDataSource.getUserStates();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearUserStates() async {
    try {
      await localUserStatesDataSource.clearUserStates();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> clearUserRoles() async {
    try {
      await localUserRolesDataSource.clearUserRoles();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, UserRoleCollection>> getUserRoles() async {
    UserRoleCollection data;
    try {
      data = await localUserRolesDataSource.getUserRoles();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }
}
