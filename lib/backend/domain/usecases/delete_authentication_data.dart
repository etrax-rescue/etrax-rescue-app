import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/types/usecase.dart';
import '../repositories/authentication_repository.dart';

class DeleteAuthenticationData extends UseCase<None, NoParams> {
  final AuthenticationRepository repository;

  DeleteAuthenticationData(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.deleteAuthenticationData();
  }
}
