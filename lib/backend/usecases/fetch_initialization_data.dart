import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/initialization_data.dart';
import '../types/usecase.dart';

class FetchInitializationData
    extends UseCase<InitializationData, FetchInitializationDataParams> {
  FetchInitializationData(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, InitializationData>> call(
      FetchInitializationDataParams params) async {
    return await repository.fetchInitializationData(
        params.appConnection, params.authenticationData);
  }
}

class FetchInitializationDataParams extends Equatable {
  FetchInitializationDataParams({
    @required this.appConnection,
    @required this.authenticationData,
  });

  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [appConnection, authenticationData];
}
