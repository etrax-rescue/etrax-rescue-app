import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/base_uri.dart';
import '../../domain/repositories/base_uri_repository.dart';
import '../datasources/base_uri_local_datasource.dart';
import '../datasources/base_uri_remote_endpoint_verification.dart';

class BaseUriRepositoryImpl implements BaseUriRepository {
  final BaseUriRemoteEndpointVerification remoteEndpointVerification;
  final BaseUriLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BaseUriRepositoryImpl({
    @required this.remoteEndpointVerification,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, BaseUri>> getBaseUri() async {
    try {
      final cachedBaseUri = await localDataSource.getCachedBaseUri();
      return Right(cachedBaseUri);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, None>> verifyAndStoreBaseUri(String baseUri) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    try {
      await remoteEndpointVerification.verifyRemoteEndpoint(baseUri);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    }
    try {
      localDataSource.cacheBaseUri(baseUri);
      return Right(None());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
