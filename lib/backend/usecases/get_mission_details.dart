import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_details_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/mission_details.dart';
import '../types/usecase.dart';

class GetMissionDetails
    extends UseCase<MissionDetailCollection, GetMissionDetailsParams> {
  GetMissionDetails(this.repository);

  final MissionDetailsRepository repository;

  @override
  Future<Either<Failure, MissionDetailCollection>> call(
      GetMissionDetailsParams params) async {
    return await repository.getMissionDetails(
        params.appConnection, params.authenticationData);
  }
}

class GetMissionDetailsParams extends Equatable {
  GetMissionDetailsParams(
      {required this.appConnection, required this.authenticationData});

  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [appConnection, authenticationData];
}
