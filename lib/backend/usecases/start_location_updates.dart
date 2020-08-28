import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/app_configuration.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';

class StartLocationUpdates extends UseCase<bool, StartLocationUpdatesParams> {
  final LocationRepository repository;
  StartLocationUpdates(this.repository);

  @override
  Future<Either<Failure, bool>> call(StartLocationUpdatesParams params) async {
    return await repository.startUpdates(
      params.accuracy,
      params.appConfiguration,
      params.notificationTitle,
      params.notificationBody,
      params.appConnection,
      params.authenticationData,
      params.label,
    );
  }
}

class StartLocationUpdatesParams extends Equatable {
  final LocationAccuracy accuracy;
  final AppConfiguration appConfiguration;
  final String notificationTitle;
  final String notificationBody;
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final String label;

  StartLocationUpdatesParams({
    @required this.accuracy,
    @required this.appConfiguration,
    @required this.notificationTitle,
    @required this.notificationBody,
    @required this.appConnection,
    @required this.authenticationData,
    @required this.label,
  });

  @override
  List<Object> get props => [
        accuracy,
        appConfiguration,
        notificationTitle,
        notificationBody,
        appConnection,
        authenticationData,
        label,
      ];
}
