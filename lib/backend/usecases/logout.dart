import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/usecase.dart';

class Logout extends UseCase<None, NoParams> {
  final AppStateRepository repository;
  Logout(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.logout();
  }
}
