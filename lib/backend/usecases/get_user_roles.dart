import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/usecase.dart';
import '../types/user_roles.dart';

class GetUserRoles extends UseCase<UserRoleCollection, NoParams> {
  GetUserRoles(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, UserRoleCollection>> call(NoParams params) async {
    return await repository.getUserRoles();
  }
}
