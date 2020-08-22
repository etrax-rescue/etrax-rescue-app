import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/types/usecase.dart';
import '../repositories/app_connection_repository.dart';

class MarkAppConnectionForUpdate extends UseCase<None, NoParams> {
  final AppConnectionRepository repository;
  MarkAppConnectionForUpdate(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.markAppConnectionForUpdate();
  }
}
