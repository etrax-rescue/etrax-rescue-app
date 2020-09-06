import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';

class GetAuthenticationData extends UseCase<AuthenticationData, NoParams> {
  final LoginRepository repository;

  GetAuthenticationData(this.repository);

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
