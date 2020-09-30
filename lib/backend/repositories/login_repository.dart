import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_login_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_organizations_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_login_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_organizations_data_source.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/organizations.dart';

abstract class LoginRepository {
  // Login and logout
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password);
  Future<Either<Failure, None>> logout();

  // Authentication
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();

  // Organizations
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection);
}

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteOrganizationsDataSource,
    @required this.localOrganizationsDataSource,
    @required this.remoteLoginDataSource,
    @required this.localLoginDataSource,
  });

  final NetworkInfo networkInfo;

  final RemoteOrganizationsDataSource remoteOrganizationsDataSource;
  final LocalOrganizationsDataSource localOrganizationsDataSource;

  final RemoteLoginDataSource remoteLoginDataSource;
  final LocalLoginDataSource localLoginDataSource;

  @override
  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection) async {
    OrganizationCollection model;
    if (await networkInfo.isConnected) {
      bool failed = false;
      try {
        model =
            await remoteOrganizationsDataSource.getOrganizations(appConnection);
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      }
      if (failed == true) {
        try {
          model = await localOrganizationsDataSource.getCachedOrganizations();
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      } else {
        try {
          await localOrganizationsDataSource.cacheOrganizations(model);
        } on CacheException {
          return Left(CacheFailure());
        }
        return Right(model);
      }
    } else {
      try {
        model = await localOrganizationsDataSource.getCachedOrganizations();
      } on CacheException {
        return Left(CacheFailure());
      }
      return Right(model);
    }
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
    } on FormatException {
      return Left(ServerFailure());
    }
    try {
      await localLoginDataSource
          .cacheSelectedOrganizationID(authenticationDataModel.organizationID);
      await localLoginDataSource
          .cacheUsername(authenticationDataModel.username);
      await localLoginDataSource.cacheToken(authenticationDataModel.token);
      await localLoginDataSource
          .cacheIssuingDate(authenticationDataModel.issuingDate);
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, None>> logout() async {
    try {
      await localLoginDataSource.deleteToken();
    } on CacheException {
      return Left(CacheFailure());
    }
    return Right(None());
  }

  @override
  Future<Either<Failure, AuthenticationData>> getAuthenticationData() async {
    AuthenticationData data;
    String username;
    String organizationID;
    String token;
    DateTime issuingDate;
    try {
      username = await localLoginDataSource.getCachedUsername();
      organizationID =
          await localLoginDataSource.getCachedSelectedOrganizationID();
      token = await localLoginDataSource.getCachedToken();
      issuingDate = await localLoginDataSource.getCachedIssuingDate();
    } on CacheException {
      return Left(CacheFailure());
    }
    data = AuthenticationData(
      organizationID: organizationID,
      username: username,
      token: token,
      issuingDate: issuingDate,
    );
    return Right(data);
  }
}
