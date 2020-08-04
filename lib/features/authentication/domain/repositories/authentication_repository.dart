import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/organizations.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/app_connection.dart';
import '../../../../core/types/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, None>> login(AppConnection appConnection,
      String organizationID, String username, String password);

  Future<Either<Failure, AuthenticationData>> getAuthenticationData();

  Future<Either<Failure, None>> deleteAuthenticationData();

  Future<Either<Failure, OrganizationCollection>> getOrganizations(
      AppConnection appConnection);
}
