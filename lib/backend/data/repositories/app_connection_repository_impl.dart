import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../types/app_connection.dart';
import '../../domain/repositories/app_connection_repository.dart';
import '../datasources/local_app_settings_data_source.dart';
import '../datasources/remote_app_connection_endpoint_verification.dart';

class AppConnectionRepositoryImpl implements AppConnectionRepository {
  final RemoteAppConnectionEndpointVerification remoteEndpointVerification;
  final LocalAppSettingsDataSource localDataSource;
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
    AppConnection model;
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
    } on Exception {
      // TODO: handle empty header error!
      return Left(ServerFailure());
    }
    try {
      localDataSource.cacheAppConnection(model);
      localDataSource.setAppConnectionUpdateStatus(false);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getAppConnectionUpdateStatus() async {
    try {
      final update = await localDataSource.getAppConnectionUpdateStatus();
      return Right(update);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> markAppConnectionForUpdate() async {
    try {
      localDataSource.setAppConnectionUpdateStatus(true);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
