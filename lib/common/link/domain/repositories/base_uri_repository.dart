import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/base_uri.dart';

abstract class BaseUriRepository {
  Future<Either<Failure, None>> verifyAndStoreBaseUri(String baseUri);
  Future<Either<Failure, BaseUri>> getBaseUri();
}
