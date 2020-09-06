import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../types/usecase.dart';
import '../repositories/mission_state_repository.dart';

class ClearMissionState extends UseCase<None, NoParams> {
  final MissionStateRepository repository;
  ClearMissionState(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams param) async {
    return await repository.clearMissionState();
  }
}
