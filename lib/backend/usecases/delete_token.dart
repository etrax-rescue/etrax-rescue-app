import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../types/usecase.dart';

class DeleteToken extends UseCase<None, NoParams> {
  DeleteToken(this.repository);

  final LoginRepository repository;

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.deleteToken();
  }
}
