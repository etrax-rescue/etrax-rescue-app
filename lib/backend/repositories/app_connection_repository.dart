import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_app_connection_data_source.dart';
import '../datasources/local/local_barcode_data_source.dart';
import '../datasources/remote/remote_app_connection_data_source.dart';
import '../types/app_connection.dart';

abstract class AppConnectionRepository {
  Future<Either<Failure, String>> scanQRCode(
      String cancelText, String flashOnText, String flashOffText);
  Future<Either<Failure, None>> setAppConnection(
      String authority, String basePath);
  Future<Either<Failure, AppConnection>> getAppConnection();
  Future<Either<Failure, None>> deleteAppConnection();
}

class AppConnectionRepositoryImpl implements AppConnectionRepository {
  AppConnectionRepositoryImpl({
    @required this.networkInfo,
    @required this.localBarcodeDataSource,
    @required this.localAppConnectionDataSource,
    @required this.remoteAppConnectionDataSource,
  });

  final NetworkInfo networkInfo;
  final LocalBarcodeDataSource localBarcodeDataSource;
  final RemoteAppConnectionDataSource remoteAppConnectionDataSource;
  final LocalAppConnectionDataSource localAppConnectionDataSource;

  @override
  Future<Either<Failure, AppConnection>> getAppConnection() async {
    try {
      final cachedAppConnection =
          await localAppConnectionDataSource.getCachedAppConnection();
      return Right(cachedAppConnection);
    } on CacheException {
      return Left(CacheFailure());
    } on FormatException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> setAppConnection(
      String authority, String basePath) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AppConnection model;
    try {
      model = await remoteAppConnectionDataSource.verifyRemoteEndpoint(
          authority, basePath);
    } on ServerException {
      return Left(ServerConnectionFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on HandshakeException {
      return Left(ServerFailure());
    }
    try {
      await localAppConnectionDataSource.cacheAppConnection(model);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> deleteAppConnection() async {
    try {
      localAppConnectionDataSource.deleteAppConnection();
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> scanQRCode(
      String cancelText, String flashOnText, String flashOffText) async {
    try {
      final result = await localBarcodeDataSource.scanQRCode(
          cancelText, flashOnText, flashOffText);
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }
}
