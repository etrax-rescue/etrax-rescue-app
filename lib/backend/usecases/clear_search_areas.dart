import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/search_area_repository.dart';
import '../types/usecase.dart';

class ClearSearchAreas extends UseCase<None, NoParams> {
  ClearSearchAreas(this.repository);

  final SearchAreaRepository repository;

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.clearSearchAreas();
  }
}
