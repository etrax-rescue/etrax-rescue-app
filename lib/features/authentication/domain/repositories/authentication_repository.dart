import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, None>> login(
    String baseUri,
    String username,
    String password,
  );
  Future<Either<Failure, AuthenticationData>> getAuthenticationData();
}
