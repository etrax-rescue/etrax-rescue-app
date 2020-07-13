import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/initialization_data_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/missions.dart';
import '../../domain/entities/user_roles.dart';
import '../../domain/entities/user_states.dart';
import '../../domain/repositories/initialization_repository.dart';
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
  Future<Either<Failure, None>> fetchInitializationData(
      String baseUri, String username, String token) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    InitializationDataModel data;
    try {
      data = await remoteInitializationDataSource.fetchInitialization(
          baseUri, username, token);
    } on ServerException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on AuthenticationException {
      return Left(AuthenticationFailure());
    }

    try {
      localAppSettingsDataSource.storeAppSettings(data.appSettingsModel);

      localUserRolesDataSource.storeUserRoles(data.userRolesModel);

      localUserStatesDataSource.storeUserStates(data.userStatesModel);

      localMissionsDataSource.insertMissions(data.missionsModel);
    } on CacheException {
      return Left(CacheFailure());
    }

    return Right(None());
  }

  @override
  Future<Either<Failure, AppSettings>> getAppSettings() {
    // TODO: implement getAppSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> clearAppSettings() {
    // TODO: implement clearAppSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Missions>> getMissions() {
    // TODO: implement getMissions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> clearMissions() {
    // TODO: implement clearMissions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserStates>> getUserStates() {
    // TODO: implement getUserStates
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> clearUserStates() {
    // TODO: implement clearUserStates
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> clearUserRoles() {
    // TODO: implement clearUserRoles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserRoles>> getUserRoles() {
    // TODO: implement getUserRoles
    throw UnimplementedError();
  }
}
