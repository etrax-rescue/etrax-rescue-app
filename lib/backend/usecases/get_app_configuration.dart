import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/app_configuration.dart';
import '../types/usecase.dart';

class GetAppConfiguration extends UseCase<AppConfiguration, NoParams> {
  GetAppConfiguration(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, AppConfiguration>> call(NoParams params) async {
    return await repository.getAppConfiguration();
  }
}
