import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/entities/app_connection.dart';

import '../../../../core/error/failures.dart';
import '../entities/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, None>> login(
      AppConnection appConnection, String username, String password);

  Future<Either<Failure, AuthenticationData>> getAuthenticationData();

  Future<Either<Failure, None>> deleteAuthenticationData();
}
