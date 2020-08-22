import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/organizations.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/local_authentication_data_source.dart';
import '../datasources/remote_login_data_source.dart';

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
    AuthenticationData data;
    try {
      data = await localAuthenticationDataSource.getCachedAuthenticationData();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(data);
  }

  @override
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AuthenticationData authenticationDataModel;
    try {
      authenticationDataModel = await remoteLoginDataSource.login(
          appConnection, organizationID, username, password);
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
  Future<Either<Failure, None>> deleteAuthenticationData() async {
    // TODO: implement this!
    await localAuthenticationDataSource.deleteAuthenticationData();
  }

  @override
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection) async {
    OrganizationCollection model;
    if (await networkInfo.isConnected) {
      bool failed = false;
      try {
        model = await remoteLoginDataSource.getOrganizations(appConnection);
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      }
      if (failed == true) {
        try {
          model = await localAuthenticationDataSource.getCachedOrganizations();
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      } else {
        try {
          await localAuthenticationDataSource.cacheOrganizations(model);
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      }
    } else {
      try {
        model = await localAuthenticationDataSource.getCachedOrganizations();
      } on CacheException {
        return Left(CacheFailure());
      }
      return Right(model);
    }
  }
}
