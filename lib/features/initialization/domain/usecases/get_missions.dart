import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../repositories/initialization_repository.dart';

class GetMissions extends UseCase<Missions, NoParams> {
  final InitializationRepository repository;
  GetMissions(this.repository);

  @override
  Future<Either<Failure, Missions>> call(NoParams params) async {
    return await repository.getMissions();
  }
}
