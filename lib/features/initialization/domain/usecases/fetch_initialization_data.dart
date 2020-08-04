import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/types/authentication_data.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/app_connection.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/initialization_repository.dart';

class FetchInitializationData
    extends UseCase<MissionCollection, FetchInitializationDataParams> {
  final InitializationRepository repository;
  FetchInitializationData(this.repository);

  @override
  Future<Either<Failure, MissionCollection>> call(
      FetchInitializationDataParams params) async {
    return await repository.fetchInitializationData(
        params.appConnection, params.authenticationData);
  }
}

class FetchInitializationDataParams extends Equatable {
  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  FetchInitializationDataParams({
    @required this.appConnection,
    @required this.authenticationData,
  });

  @override
  List<Object> get props => [appConnection, authenticationData];
}
