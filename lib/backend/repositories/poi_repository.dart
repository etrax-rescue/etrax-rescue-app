import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_image_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_location_data_source.dart';
import 'package:flutter/services.dart';

import '../../core/error/failures.dart';

abstract class PoiRepository {
  Future<Either<Failure, String>> takePhoto();
  Future<Either<Failure, None>> sendPOI(String imagePath, String description);
}

class PoiRepositoryImpl implements PoiRepository {
  PoiRepositoryImpl(this.imageDataSource, this.locationDataSource);

  final LocalImageDataSource imageDataSource;
  final LocalLocationDataSource locationDataSource;

  @override
  Future<Either<Failure, None>> sendPOI(String imagePath, String description) {
    // TODO: implement sendPOI
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> takePhoto() async {
    String imagePath;
    try {
      imagePath = await imageDataSource.takePhoto();
    } on PlatformException {
      return Left(PlatformFailure());
    }
    return Right(imagePath);
  }
}
