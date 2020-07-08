import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, None>> login(
      String baseUri, String username, String password);
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
}
