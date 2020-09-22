import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_mission_state_data_source.dart';
import '../datasources/remote/remote_mission_state_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/mission_state.dart';
import '../types/missions.dart';
import '../types/user_roles.dart';
import '../types/user_states.dart';

abstract class MissionStateRepository {
  // Selected Mission
  Future<Either<Failure, None>> setSelectedMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission);

  Future<Either<Failure, Mission>> getSelectedMission();

  // Selected UserState
  Future<Either<Failure, None>> setSelectedUserState(
      AppConnection appConnection,
      AuthenticationData authenticationData,
      UserState state,
      LocationData currentLocation);

  // Selected UserRole
  Future<Either<Failure, None>> setSelectedUserRole(AppConnection appConnection,
      AuthenticationData authenticationData, UserRole role);

  Future<Either<Failure, MissionState>> getMissionState();

  Future<Either<Failure, None>> clearMissionState();
}

class MissionStateRepositoryImpl implements MissionStateRepository {
  MissionStateRepositoryImpl({
    @required this.localMissionStateDataSource,
    @required this.remoteMissionStateDataSource,
    @required this.networkInfo,
  });

  final NetworkInfo networkInfo;

  final LocalMissionStateDataSource localMissionStateDataSource;
  final RemoteMissionStateDataSource remoteMissionStateDataSource;

  @override
  Future<Either<Failure, None>> setSelectedUserRole(AppConnection appConnection,
      AuthenticationData authenticationData, UserRole role) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    try {
      await remoteMissionStateDataSource.selectUserRole(
          appConnection, authenticationData, role);
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
      await localMissionStateDataSource.cacheSelectedUserRole(role);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> setSelectedUserState(
      AppConnection appConnection,
      AuthenticationData authenticationData,
      UserState state,
      LocationData currentLocation) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    try {
      await remoteMissionStateDataSource.selectUserState(
          appConnection, authenticationData, state, currentLocation);
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
      await localMissionStateDataSource.cacheSelectedUserState(state);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> setSelectedMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    try {
      await remoteMissionStateDataSource.selectMission(
          appConnection, authenticationData, mission);
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

  @override
  Future<Either<Failure, None>> clearMissionState() async {
    try {
      await localMissionStateDataSource.clear();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, Mission>> getSelectedMission() async {
    Mission mission;
    try {
      mission = await localMissionStateDataSource.getCachedSelectedMission();
      return Right(mission);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
