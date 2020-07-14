import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/initialization_repository.dart';

class FetchInitializationData
    extends UseCase<None, FetchInitializationDataParams> {
  final InitializationRepository repository;
  FetchInitializationData(this.repository);

  @override
  Future<Either<Failure, None>> call(
      FetchInitializationDataParams params) async {
    return await repository.fetchInitializationData(
        params.appConnection, params.username, params.token);
  }
}

class FetchInitializationDataParams extends Equatable {
  final AppConnection appConnection;
  final String username;
  final String token;

  FetchInitializationDataParams({
    @required this.appConnection,
    @required this.username,
    @required this.token,
  });

  @override
  List<Object> get props => [appConnection, username, token];
}
