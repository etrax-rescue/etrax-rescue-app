import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/app_connection.dart';
import '../types/usecase.dart';

class GetAppConnection extends UseCase<AppConnection, NoParams> {
  final AppStateRepository repository;
  GetAppConnection(this.repository);

  @override
  Future<Either<Failure, AppConnection>> call(NoParams params) async {
    return await repository.getAppConnection();
  }
}
