import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/person_image.dart';
import '../../domain/repositories/person_image_repository.dart';

class PersonInfoRepositoryImpl implements PersonImageRepository {
  @override
  Future<Either<Failure, PersonImage>> getPersonImage(
      String url, String token) {
    // TODO: implement getPersonImage
    throw UnimplementedError();
  }
}
