import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/types/app_connection.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/initialization_repository.dart';
import '../datasources/local_app_settings_data_source.dart';
import '../datasources/local_missions_data_source.dart';
import '../datasources/local_user_roles_data_source.dart';
import '../datasources/local_user_states_data_source.dart';
import '../datasources/remote_initialization_data_source.dart';
import '../models/app_settings_model.dart';
import '../models/initialization_data_model.dart';
import '../models/missions_model.dart';
import '../models/user_roles_model.dart';
import '../models/user_states_model.dart';

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
  Future<Either<Failure, MissionCollection>> fetchInitializationData(
      AppConnection appConnection, String username, String token) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    InitializationDataModel initializationData;
    try {
      initializationData = await remoteInitializationDataSource
          .fetchInitialization(appConnection, username, token);
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
    }

    try {
      localAppSettingsDataSource
          .storeAppSettings(initializationData.appSettingsModel);

      localUserRolesDataSource
          .storeUserRoles(initializationData.userRoleCollectionModel);

      localUserStatesDataSource
          .storeUserStates(initializationData.userStateCollectionModel);

      localMissionsDataSource
          .insertMissions(initializationData.missionCollectionModel);
    } on CacheException {
      return Left(CacheFailure());
    }

    return Right(initializationData.missionCollectionModel);
  }

  @override
  Future<Either<Failure, AppSettings>> getAppSettings() async {
    AppSettingsModel data;
    try {
      data = await localAppSettingsDataSource.getAppSettings();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> clearAppSettings() async {
    try {
      await localAppSettingsDataSource.clearAppSettings();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, MissionCollectionModel>> getMissions() async {
    MissionCollectionModel data;
    try {
      data = await localMissionsDataSource.getMissions();
    } on CacheException {
      return Left(CacheFailure());
    } on InvalidDataException {
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
  Future<Either<Failure, UserStateCollectionModel>> getUserStates() async {
    UserStateCollectionModel data;
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
  Future<Either<Failure, UserRoleCollectionModel>> getUserRoles() async {
    UserRoleCollectionModel data;
    try {
      data = await localUserRolesDataSource.getUserRoles();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }
}
