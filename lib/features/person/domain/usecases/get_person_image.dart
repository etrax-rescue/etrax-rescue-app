import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person_image.dart';
import '../repositories/person_image_repository.dart';

class GetPersonImage extends UseCase<PersonImage, UrlTokenParams> {
  final PersonImageRepository repository;

  GetPersonImage(this.repository);

  @override
  Future<Either<Failure, PersonImage>> call(UrlTokenParams params) async {
    return await repository.getPersonImage(params.url, params.token);
  }
}
