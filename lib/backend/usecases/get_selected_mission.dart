import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/missions.dart';
import '../types/usecase.dart';

class GetSelectedMission extends UseCase<Mission, NoParams> {
  final AppStateRepository repository;
  GetSelectedMission(this.repository);

  @override
  Future<Either<Failure, Mission>> call(NoParams param) async {
    return await repository.getSelectedMission();
  }
}
