import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/app_connection.dart';
import '../types/organizations.dart';
import '../types/usecase.dart';

class GetOrganizations
    extends UseCase<OrganizationCollection, GetOrganizationsParams> {
  GetOrganizations(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, OrganizationCollection>> call(
      GetOrganizationsParams params) async {
    return await repository.getOrganizations(params.appConnection);
  }
}

class GetOrganizationsParams extends Equatable {
  GetOrganizationsParams({required this.appConnection});

  final AppConnection appConnection;

  @override
  List<Object> get props => [appConnection];
}
