import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/app_connection.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/app_connection_repository.dart';

class GetAppConnection extends UseCase<AppConnection, NoParams> {
  final AppConnectionRepository repository;
  GetAppConnection(this.repository);

  @override
  Future<Either<Failure, AppConnection>> call(NoParams params) async {
    return await repository.getAppConnection();
  }
}