import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/app_connection.dart';
import '../types/usecase.dart';

class Login extends UseCase<None, LoginParams> {
  Login(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, None>> call(LoginParams params) async {
    return await repository.login(params.appConnection, params.organizationID,
        params.username, params.password);
  }
}

class LoginParams extends Equatable {
  LoginParams({
    @required this.appConnection,
    @required this.organizationID,
    @required this.username,
    @required this.password,
  });

  final AppConnection appConnection;
  final String organizationID;
  final String username;
  final String password;

  @override
  List<Object> get props => [appConnection, organizationID, username, password];
}
