import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:moor/moor.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_mission_details_data_source.dart';
import '../datasources/remote/remote_mission_details_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/mission_details.dart';

abstract class MissionDetailsRepository {
  Future<Either<Failure, MissionDetailCollection>> getMissionDetails(
      AppConnection appConnection, AuthenticationData authenticationData);

  Future<Either<Failure, None>> clearMissionDetails();
}

class MissionDetailsRepositoryImpl implements MissionDetailsRepository {
  MissionDetailsRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDetailsDataSource,
    @required this.localMissionDetailsDataSource,
    @required this.cacheManager,
  });

  final NetworkInfo networkInfo;
  final RemoteMissionDetailsDataSource remoteDetailsDataSource;
  final LocalMissionDetailsDataSource localMissionDetailsDataSource;
  final DefaultCacheManager cacheManager;

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
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      } on AuthenticationException {
        return Left(AuthenticationFailure());
      }

      if (failed == true) {
        try {
          collection =
              await localMissionDetailsDataSource.getCachedMissionDetails();
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(collection);
      } else {
        try {
          await localMissionDetailsDataSource.cacheMissionDetails(collection);
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(collection);
      }
    } else {
      try {
        collection =
            await localMissionDetailsDataSource.getCachedMissionDetails();
      } on CacheException {
        return Left(CacheFailure());
      }
      return Right(collection);
    }
  }

  @override
  Future<Either<Failure, None>> clearMissionDetails() async {
    await cacheManager.emptyCache();
    try {
      await localMissionDetailsDataSource.deleteCachedMissionDetails();
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
