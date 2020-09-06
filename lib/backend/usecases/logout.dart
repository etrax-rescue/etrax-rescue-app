import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/usecase.dart';

class Logout extends UseCase<None, NoParams> {
  final LoginRepository repository;
  Logout(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.logout();
  }
}
