import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person_info.dart';
import '../repositories/person_info_repository.dart';

class GetPersonInfo implements UseCase<PersonInfo, UrlTokenParams> {
  final PersonInfoRepository repository;

  GetPersonInfo(this.repository);

  @override
  Future<Either<Failure, PersonInfo>> call(UrlTokenParams params) async {
    return await repository.getPersonInfo(params.url, params.token);
  }
}
