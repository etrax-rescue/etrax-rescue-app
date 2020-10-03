import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/missions.dart';
import '../types/usecase.dart';

class GetMissions extends UseCase<MissionCollection, NoParams> {
  final InitializationRepository repository;
  GetMissions(this.repository);

  @override
  Future<Either<Failure, MissionCollection>> call(NoParams params) async {
    return await repository.getMissions();
  }
}
