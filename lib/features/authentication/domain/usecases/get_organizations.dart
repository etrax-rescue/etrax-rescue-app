import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/organizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/authentication_repository.dart';

class GetOrganizations
    extends UseCase<OrganizationCollection, GetOrganizationsParams> {
  final AuthenticationRepository repository;

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
