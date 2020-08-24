import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../types/usecase.dart';
import '../types/app_configuration.dart';
import '../repositories/initialization_repository.dart';

class GetAppConfiguration extends UseCase<AppConfiguration, NoParams> {
  final InitializationRepository repository;
  GetAppConfiguration(this.repository);

  @override
  Future<Either<Failure, AppConfiguration>> call(NoParams params) async {
    return await repository.getAppConfiguration();
  }
}
