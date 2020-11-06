import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';

class Logout extends UseCase<None, LogoutParams> {
  Logout(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, None>> call(LogoutParams params) async {
    return await repository.logout(
        params.appConnection, params.authenticationData);
  }
}

class LogoutParams extends Equatable {
  LogoutParams(
      {@required this.appConnection, @required this.authenticationData});

  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [appConnection, authenticationData];
}
