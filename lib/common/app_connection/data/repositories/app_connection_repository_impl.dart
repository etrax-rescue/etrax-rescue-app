import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connection/data/models/app_connection_model.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_connection.dart';
import '../../domain/repositories/app_connection_repository.dart';
import '../datasources/app_connection_local_datasource.dart';
import '../datasources/app_connection_remote_endpoint_verification.dart';

class AppConnectionRepositoryImpl implements AppConnectionRepository {
  final AppConnectionRemoteEndpointVerification remoteEndpointVerification;
  final AppConnectionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AppConnectionRepositoryImpl({
    @required this.remoteEndpointVerification,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, AppConnection>> getAppConnection() async {
    try {
      final cachedAppConnection =
          await localDataSource.getCachedAppConnection();
      return Right(cachedAppConnection);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> verifyAndStoreAppConnection(
      String authority, String basePath) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AppConnectionModel model;
    try {
      model = await remoteEndpointVerification.verifyRemoteEndpoint(
          authority, basePath);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on HandshakeException {
      return Left(ServerFailure());
    }
    try {
      localDataSource.cacheAppConnection(model);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
