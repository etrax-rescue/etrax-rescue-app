import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class Login extends UseCase<None, LoginParams> {
  final AuthenticationRepository repository;
  Login(this.repository);

  @override
  Future<Either<Failure, None>> call(LoginParams params) async {
    return await repository.login(
        params.baseUri, params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String baseUri;
  final String username;
  final String password;

  LoginParams({
    @required this.baseUri,
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [baseUri, username, password];
}
