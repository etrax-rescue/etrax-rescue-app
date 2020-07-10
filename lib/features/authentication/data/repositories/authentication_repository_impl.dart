import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/local_authentication_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/remote_login_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final RemoteLoginDataSource remoteLoginDataSource;
  final LocalAuthenticationDataSource localAuthenticationDataSource;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({
    @required this.remoteLoginDataSource,
    @required this.localAuthenticationDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    AuthenticationDataModel data;
    try {
      data = await localAuthenticationDataSource.getCachedAuthenticationData();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> login(
      String baseUri, String username, String password) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AuthenticationDataModel authenticationDataModel;
    try {
      authenticationDataModel =
          await remoteLoginDataSource.login(baseUri, username, password);
    } on ServerException {
      return Left(ServerFailure());
    } on TimeoutException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ServerFailure());
    } on LoginException {
      return Left(LoginFailure());
    }
    try {
      localAuthenticationDataSource
          .cacheAuthenticationData(authenticationDataModel);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> deleteAuthenticationData() {
    localAuthenticationDataSource.deleteAuthenticationData();
  }
}
