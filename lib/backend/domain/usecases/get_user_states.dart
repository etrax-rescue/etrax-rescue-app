import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/types/usecase.dart';
import '../../domain/entities/user_states.dart';
import '../repositories/initialization_repository.dart';

class GetUserStates extends UseCase<UserStateCollection, NoParams> {
  final InitializationRepository repository;
  GetUserStates(this.repository);

  @override
  Future<Either<Failure, UserStateCollection>> call(NoParams params) async {
    return await repository.getUserStates();
  }
}