import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_details_repository.dart';
import '../types/usecase.dart';

class ClearMissionDetails extends UseCase<None, NoParams> {
  ClearMissionDetails(this.repository);

  final MissionDetailsRepository repository;

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.clearMissionDetails();
  }
}
