import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../types/app_connection.dart';
import '../types/usecase.dart';
import '../types/organizations.dart';
import '../repositories/app_state_repository.dart';

class GetOrganizations
    extends UseCase<OrganizationCollection, GetOrganizationsParams> {
  final AppStateRepository repository;

  GetOrganizations(this.repository);

  @override
  Future<Either<Failure, OrganizationCollection>> call(
      GetOrganizationsParams params) async {
    return await repository.getOrganizations(params.appConnection);
  }
}

class GetOrganizationsParams extends Equatable {
  final AppConnection appConnection;

  GetOrganizationsParams({@required this.appConnection});

  @override
  List<Object> get props => [appConnection];
}
