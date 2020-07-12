import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/initialization_repository.dart';

class GetUserRoles extends UseCase<UserRoles, NoParams> {
  final InitializationRepository repository;
  GetUserRoles(this.repository);

  @override
  Future<Either<Failure, UserRoles>> call(NoParams params) async {
    return await repository.getUserRoles();
  }
}
