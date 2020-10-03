import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';

class GetAuthenticationData extends UseCase<AuthenticationData, NoParams> {
  GetAuthenticationData(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
