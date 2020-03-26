import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/person_image.dart';

abstract class PersonImageRepository {
  Future<Either<Failure, PersonImage>> getPersonImage(String url, String token);
}
