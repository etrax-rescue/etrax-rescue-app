import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/app_configuration.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class RequestLocationService
    extends UseCase<bool, RequestLocationServiceParams> {
  final LocationRepository repository;
  RequestLocationService(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      RequestLocationServiceParams params) async {
    return await repository.requestService(
        params.accuracy, params.appConfiguration);
  }
}

class RequestLocationServiceParams extends Equatable {
  RequestLocationServiceParams(
      {@required this.accuracy, @required this.appConfiguration});

  final LocationAccuracy accuracy;
  final AppConfiguration appConfiguration;

  @override
  List<Object> get props => [accuracy, appConfiguration];
}
