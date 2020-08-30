import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class ClearLocationCache extends UseCase<None, NoParams> {
  final LocationRepository repository;
  ClearLocationCache(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.clearLocationCache();
  }
}
