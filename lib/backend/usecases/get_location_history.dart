// @dart=2.9
import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class GetLocationHistory
    extends UseCase<List<LocationData>, GetLocationHistoryParams> {
  GetLocationHistory(this.repository);

  final LocationRepository repository;

  @override
  Future<Either<Failure, List<LocationData>>> call(
      GetLocationHistoryParams params) async {
    return await repository.getLocations(params.label);
  }
}

class GetLocationHistoryParams extends Equatable {
  GetLocationHistoryParams({@required this.label});

  final String label;

  @override
  List<Object> get props => [label];
}
