import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_location_data_source.dart';
import 'package:etrax_rescue_app/backend/types/app_configuration.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class LocationRepository {
  Future<Either<Failure, PermissionStatus>> hasPermission();

  Future<Either<Failure, PermissionStatus>> requestPermission();

  Future<Either<Failure, bool>> serviceEnabled(
      LocationAccuracy accuracy, AppConfiguration appConfiguration);

  Future<Either<Failure, bool>> requestService(
      LocationAccuracy accuracy, AppConfiguration appConfiguration);

  Future<Either<Failure, bool>> updatesActive();

  Future<Either<Failure, bool>> startUpdates(
    LocationAccuracy accuracy,
    AppConfiguration appConfiguration,
    String notificationTitle,
    String notificationBody,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    String label,
  );

  Future<Either<Failure, bool>> stopUpdates();

  Future<Either<Failure, Stream<LocationData>>> getLocationUpdateStream(
      String label);

  Future<Either<Failure, List<LocationData>>> getLocations(String label);

  Future<Either<Failure, None>> clearLocationCache();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocalLocationDataSource localLocationDataSource;
  LocationRepositoryImpl({@required this.localLocationDataSource});

  @override
  Future<Either<Failure, Stream<LocationData>>> getLocationUpdateStream(
      String label) async {
    try {
      final result =
          await localLocationDataSource.getLocationUpdateStream(label);
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> hasPermission() async {
    try {
      final result = await localLocationDataSource.hasPermission();
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestPermission() async {
    try {
      final result = await localLocationDataSource.requestPermission();
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> requestService(
      LocationAccuracy accuracy, AppConfiguration appConfiguration) async {
    try {
      final result = await localLocationDataSource.requestService(
          accuracy,
          appConfiguration.locationUpdateInterval,
          appConfiguration.locationUpdateMinDistance.toDouble());
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> serviceEnabled(
      LocationAccuracy accuracy, AppConfiguration appConfiguration) async {
    try {
      final result = await localLocationDataSource.serviceEnabled(
          accuracy,
          appConfiguration.locationUpdateInterval,
          appConfiguration.locationUpdateMinDistance.toDouble());
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> startUpdates(
      LocationAccuracy accuracy,
      AppConfiguration appConfiguration,
      String notificationTitle,
      String notificationBody,
      AppConnection appConnection,
      AuthenticationData authenticationData,
      String label) async {
    try {
      final result = await localLocationDataSource.startUpdates(
        accuracy,
        appConfiguration.locationUpdateInterval,
        appConfiguration.locationUpdateMinDistance.toDouble(),
        notificationTitle,
        notificationBody,
        appConnection,
        authenticationData,
        label,
      );
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> stopUpdates() async {
    try {
      final result = await localLocationDataSource.stopUpdates();
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updatesActive() {
    // TODO: implement updatesActive
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<LocationData>>> getLocations(String label) async {
    try {
      final result = await localLocationDataSource.getLocations(label);
      return Right(result);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, None>> clearLocationCache() async {
    try {
      final result = await localLocationDataSource.clearLocationCache();
      return Right(None());
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }
}
