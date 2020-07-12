import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_connection.dart';
import '../repositories/app_connection_repository.dart';

class GetAppConnection extends UseCase<AppConnection, NoParams> {
  final AppConnectionRepository repository;
  GetAppConnection(this.repository);

  @override
  Future<Either<Failure, AppConnection>> call(NoParams params) async {
    return await repository.getAppConnection();
  }
}
