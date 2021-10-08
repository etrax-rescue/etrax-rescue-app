// @dart=2.9
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/local_image_data_source.dart';
import '../datasources/local/local_location_data_source.dart';
import '../datasources/remote/remote_poi_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/poi.dart';

abstract class PoiRepository {
  Future<Either<Failure, Poi>> capture();
  Future<Either<Failure, Stream<double>>> sendPOI(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi);
}

class PoiRepositoryImpl implements PoiRepository {
  PoiRepositoryImpl({
    @required this.networkInfo,
    @required this.imageDataSource,
    @required this.locationDataSource,
    @required this.remotePoiDataSource,
  });

  final NetworkInfo networkInfo;
  final LocalImageDataSource imageDataSource;
  final LocalLocationDataSource locationDataSource;
  final RemotePoiDataSource remotePoiDataSource;

  @override
  Future<Either<Failure, Stream<double>>> sendPOI(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }
    try {
      final result = await remotePoiDataSource.sendPoi(
          appConnection, authenticationData, poi);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Poi>> capture() async {
    try {
      final imagePath = await imageDataSource.takePhoto();
      if (imagePath == null) return Left(PlatformFailure());

      final currentLocation = await locationDataSource.getLastLocation();
      if (currentLocation == null) return Left(PlatformFailure());

      final poi = Poi(imagePath: imagePath, locationData: currentLocation);
      return Right(poi);
    } on PlatformException {
      return Left(PlatformFailure());
    }
  }
}
