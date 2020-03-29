import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/person/domain/usecases/person_retrieval_params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person_image.dart';
import '../repositories/person_image_repository.dart';

class GetPersonImage extends UseCase<PersonImage, PersonRetrievalParams> {
  final PersonImageRepository repository;

  GetPersonImage(this.repository);

  @override
  Future<Either<Failure, PersonImage>> call(
      PersonRetrievalParams params) async {
    return await repository.getPersonImage(
        params.uri, params.token, params.eid);
  }
}
