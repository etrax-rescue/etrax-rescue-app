import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class StopLocationUpdates extends UseCase<bool, NoParams> {
  final LocationRepository repository;
  StopLocationUpdates(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.stopUpdates();
  }
}
