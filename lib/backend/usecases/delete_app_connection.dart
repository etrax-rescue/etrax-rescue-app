import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../types/usecase.dart';
import '../repositories/app_state_repository.dart';

class DeleteAppConnection extends UseCase<None, NoParams> {
  final AppStateRepository repository;
  DeleteAppConnection(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.deleteAppConnection();
  }
}
