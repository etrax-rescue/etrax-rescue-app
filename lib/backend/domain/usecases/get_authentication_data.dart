import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../types/usecase.dart';
import '../../types/authentication_data.dart';
import '../repositories/authentication_repository.dart';

class GetAuthenticationData extends UseCase<AuthenticationData, NoParams> {
  final AuthenticationRepository repository;

  GetAuthenticationData(this.repository);

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
