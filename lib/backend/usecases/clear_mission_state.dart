import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_state_repository.dart';
import '../types/usecase.dart';

class ClearMissionState extends UseCase<None, NoParams> {
  ClearMissionState(this.repository);

  final MissionStateRepository repository;

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.clearMissionState();
  }
}
