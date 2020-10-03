import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_app_configuration_data_source.dart';
import '../datasources/local/local_missions_data_source.dart';
import '../datasources/local/local_quick_actions_data_source.dart';
import '../datasources/local/local_user_roles_data_source.dart';
import '../datasources/local/local_user_states_data_source.dart';
import '../datasources/remote/remote_initialization_data_source.dart';
import '../types/app_configuration.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/initialization_data.dart';
import '../types/missions.dart';
import '../types/quick_actions.dart';
import '../types/user_roles.dart';
import '../types/user_states.dart';

abstract class InitializationRepository {
  Future<Either<Failure, InitializationData>> fetchInitializationData(
      AppConnection appConnection, AuthenticationData authenticationData);

  Future<Either<Failure, InitializationData>> getInitializationData();

  Future<Either<Failure, MissionCollection>> getMissions();
  Future<Either<Failure, None>> clearMissions();

  Future<Either<Failure, AppConfiguration>> getAppConfiguration();
  Future<Either<Failure, None>> clearAppConfiguration();

  Future<Either<Failure, UserStateCollection>> getUserStates();
  Future<Either<Failure, None>> clearUserStates();

  Future<Either<Failure, UserRoleCollection>> getUserRoles();
  Future<Either<Failure, None>> clearUserRoles();

  Future<Either<Failure, QuickActionCollection>> getQuickActions();
  Future<Either<Failure, None>> clearQuickActions();
}

class InitializationRepositoryImpl implements InitializationRepository {
  InitializationRepositoryImpl({
    @required this.remoteInitializationDataSource,
    @required this.localUserStatesDataSource,
    @required this.localAppConfigurationDataSource,
    @required this.localMissionsDataSource,
    @required this.localUserRolesDataSource,
    @required this.localQuickActionDataSource,
    @required this.networkInfo,
  });

  final RemoteInitializationDataSource remoteInitializationDataSource;
  final LocalUserStatesDataSource localUserStatesDataSource;
  final LocalAppConfigurationDataSource localAppConfigurationDataSource;
  final LocalMissionsDataSource localMissionsDataSource;
  final LocalUserRolesDataSource localUserRolesDataSource;
  final LocalQuickActionDataSource localQuickActionDataSource;
  final NetworkInfo networkInfo;

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
      return Left(ServerFailure());
    } on Exception {
      return Left(UnknownFailure());
    }

    try {
      localAppConfigurationDataSource
          .setAppConfiguration(initializationData.appConfiguration);

      localUserRolesDataSource
          .storeUserRoles(initializationData.userRoleCollection);

      localUserStatesDataSource
          .storeUserStates(initializationData.userStateCollection);

      localMissionsDataSource
          .insertMissions(initializationData.missionCollection);

      localQuickActionDataSource
          .storeQuickActions(initializationData.quickActionCollection);
    } on CacheException {
      return Left(CacheFailure());
    }

    return Right(initializationData);
  }

  @override
  Future<Either<Failure, AppConfiguration>> getAppConfiguration() async {
    AppConfiguration data;
    try {
      data = await localAppConfigurationDataSource.getAppConfiguration();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearAppConfiguration() async {
    try {
      await localAppConfigurationDataSource.deleteAppConfiguration();
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

  @override
  Future<Either<Failure, InitializationData>> getInitializationData() async {
    try {
      final configuration =
          await localAppConfigurationDataSource.getAppConfiguration();
      final missions = await localMissionsDataSource.getMissions();
      final roles = await localUserRolesDataSource.getUserRoles();
      final states = await localUserStatesDataSource.getUserStates();
      final actions = await localQuickActionDataSource.getQuickActions();
      final initializationData = InitializationData(
        appConfiguration: configuration,
        missionCollection: missions,
        userStateCollection: states,
        userRoleCollection: roles,
        quickActionCollection: actions,
      );
      return Right(initializationData);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, QuickActionCollection>> getQuickActions() async {
    QuickActionCollection data;
    try {
      data = await localQuickActionDataSource.getQuickActions();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearQuickActions() async {
    try {
      await localQuickActionDataSource.clearQuickActions();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }
}
