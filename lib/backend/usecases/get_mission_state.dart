import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/mission_state.dart';
import '../types/usecase.dart';

class GetMissionState extends UseCase<MissionState, NoParams> {
  final AppStateRepository repository;
  GetMissionState(this.repository);

  @override
  Future<Either<Failure, MissionState>> call(NoParams params) async {
    return await repository.getMissionState();
  }
}
