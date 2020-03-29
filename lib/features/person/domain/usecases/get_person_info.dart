import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/person/domain/usecases/person_retrieval_params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person_info.dart';
import '../repositories/person_info_repository.dart';

class GetPersonInfo implements UseCase<PersonInfo, PersonRetrievalParams> {
  final PersonInfoRepository repository;

  GetPersonInfo(this.repository);

  @override
  Future<Either<Failure, PersonInfo>> call(PersonRetrievalParams params) async {
    return await repository.getPersonInfo(params.uri, params.token, params.eid);
  }
}
