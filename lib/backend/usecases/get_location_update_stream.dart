import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class GetLocationUpdateStream
    extends UseCase<Stream<LocationData>, GetLocationUpdateStreamParams> {
  GetLocationUpdateStream(this.repository);

  final LocationRepository repository;

  @override
  Future<Either<Failure, Stream<LocationData>>> call(
      GetLocationUpdateStreamParams params) async {
    return await repository.getLocationUpdateStream(params.label);
  }
}

class GetLocationUpdateStreamParams extends Equatable {
  GetLocationUpdateStreamParams({@required this.label});

  final String label;

  @override
  List<Object> get props => [label];
}
