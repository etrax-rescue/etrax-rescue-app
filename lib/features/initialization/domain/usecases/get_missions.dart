import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/mission.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/initialization_repository.dart';

class GetMissions extends UseCase<List<Mission>, NoParams> {
  final InitializationRepository repository;
  GetMissions(this.repository);

  @override
  Future<Either<Failure, List<Mission>>> call(NoParams params) async {
    return await repository.getMissions();
  }
}
