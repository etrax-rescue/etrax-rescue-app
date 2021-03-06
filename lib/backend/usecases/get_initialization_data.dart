import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/initialization_data.dart';
import '../types/usecase.dart';

class GetInitializationData extends UseCase<InitializationData, NoParams> {
  GetInitializationData(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, InitializationData>> call(NoParams params) async {
    return await repository.getInitializationData();
  }
}
