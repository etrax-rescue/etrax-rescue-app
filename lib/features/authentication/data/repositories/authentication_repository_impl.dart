import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/organizations_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/organizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/types/app_connection.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/local_authentication_data_source.dart';
import '../datasources/remote_login_data_source.dart';
import '../models/authentication_data_model.dart';

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
      AppConnection appConnection, String username, String password) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    AuthenticationDataModel authenticationDataModel;
    try {
      authenticationDataModel =
          await remoteLoginDataSource.login(appConnection, username, password);
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
    OrganizationCollectionModel model;
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
