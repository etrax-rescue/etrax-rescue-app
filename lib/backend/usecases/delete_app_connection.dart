import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/app_connection_repository.dart';
import '../types/usecase.dart';

class DeleteAppConnection extends UseCase<None, NoParams> {
  final AppConnectionRepository repository;
  DeleteAppConnection(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.deleteAppConnection();
  }
}
