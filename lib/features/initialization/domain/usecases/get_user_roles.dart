import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../entities/user_roles.dart';
import '../repositories/initialization_repository.dart';

class GetUserRoles extends UseCase<UserRoleCollection, NoParams> {
  final InitializationRepository repository;
  GetUserRoles(this.repository);

  @override
  Future<Either<Failure, UserRoleCollection>> call(NoParams params) async {
    return await repository.getUserRoles();
  }
}
