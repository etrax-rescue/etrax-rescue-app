import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/initialization_repository.dart';

class GetUserStates extends UseCase<UserStates, NoParams> {
  final InitializationRepository repository;
  GetUserStates(this.repository);

  @override
  Future<Either<Failure, UserStates>> call(NoParams params) async {
    return await repository.getUserStates();
  }
}
