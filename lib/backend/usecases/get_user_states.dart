import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/usecase.dart';
import '../types/user_states.dart';

class GetUserStates extends UseCase<UserStateCollection, NoParams> {
  GetUserStates(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, UserStateCollection>> call(NoParams params) async {
    return await repository.getUserStates();
  }
}
