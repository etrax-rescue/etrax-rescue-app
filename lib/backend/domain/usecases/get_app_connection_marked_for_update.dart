import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../types/usecase.dart';
import '../repositories/app_connection_repository.dart';

class GetAppConnectionMarkedForUpdate extends UseCase<bool, NoParams> {
  final AppConnectionRepository repository;
  GetAppConnectionMarkedForUpdate(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getAppConnectionUpdateStatus();
  }
}
