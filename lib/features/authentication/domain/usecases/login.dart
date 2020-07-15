import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/app_connection.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/authentication_repository.dart';

class Login extends UseCase<None, LoginParams> {
  final AuthenticationRepository repository;
  Login(this.repository);

  @override
  Future<Either<Failure, None>> call(LoginParams params) async {
    return await repository.login(
        params.appConnection, params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final AppConnection appConnection;
  final String username;
  final String password;

  LoginParams({
    @required this.appConnection,
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [appConnection, username, password];
}
