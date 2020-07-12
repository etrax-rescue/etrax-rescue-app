import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_app_settings_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_missions_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/app_settings.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:flutter/material.dart';

class InitializationRepositoryImpl implements InitializationRepository {
  final RemoteInitializationDataSource remoteInitializationDataSource;
  final LocalUserStatesDataSource localUserStatesDataSource;
  final LocalAppSettingsDataSource localAppSettingsDataSource;
  final LocalMissionsDataSource localMissionsDataSource;
  final NetworkInfo networkInfo;

  InitializationRepositoryImpl({
    @required this.remoteInitializationDataSource,
    @required this.localUserStatesDataSource,
    @required this.localAppSettingsDataSource,
    @required this.localMissionsDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, None>> fetchInitializationData(
      String baseUri, String username, String token) {
    // TODO: implement fetchInitializationData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AppSettings>> getAppSettings() {
    // TODO: implement getAppSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Missions>> getMissions() {
    // TODO: implement getMissions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> login(
      String baseUri, String username, String token) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserStates>> getUserStates() {
    // TODO: implement getUserStates
    throw UnimplementedError();
  }
}
