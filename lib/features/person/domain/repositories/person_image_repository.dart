import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/person_image.dart';

abstract class PersonImageRepository {
  Future<Either<Failure, PersonImage>> getPersonImage(
      Uri uri, String token, String eid);
}
