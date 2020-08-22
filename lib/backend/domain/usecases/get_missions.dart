import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../types/usecase.dart';
import '../../types/missions.dart';
import '../repositories/initialization_repository.dart';

class GetMissions extends UseCase<MissionCollection, NoParams> {
  final InitializationRepository repository;
  GetMissions(this.repository);

  @override
  Future<Either<Failure, MissionCollection>> call(NoParams params) async {
    return await repository.getMissions();
  }
}
