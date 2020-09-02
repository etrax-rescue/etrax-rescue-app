import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/remote/remote_mission_details_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/mission_details.dart';

abstract class MissionDetailRepository {
  Future<Either<Failure, MissionDetailCollection>> getMissionDetails(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class MissionDetailRepositoryImpl implements MissionDetailRepository {
  MissionDetailRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDetailsDataSource,
  });

  final NetworkInfo networkInfo;
  final RemoteMissionDetailsDataSource remoteDetailsDataSource;

  @override
  Future<Either<Failure, MissionDetailCollection>> getMissionDetails(
      AppConnection appConnection,
      AuthenticationData authenticationData) async {
    MissionDetailCollection collection;
    if (await networkInfo.isConnected) {
      bool failed = false;
      try {
        collection = await remoteDetailsDataSource.fetchMissionDetails(
            appConnection, authenticationData);
        return Right(collection);
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      }
      return Left(ServerFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}
