import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/types/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../repositories/initialization_repository.dart';

class GetAppSettings extends UseCase<AppSettings, NoParams> {
  final InitializationRepository repository;
  GetAppSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return await repository.getAppSettings();
  }
}
