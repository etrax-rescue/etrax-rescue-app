import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/person_info.dart';

abstract class PersonInfoRepository {
  Future<Either<Failure, PersonInfo>> getPersonInfo(
      Uri uri, String token, String eid);
}
