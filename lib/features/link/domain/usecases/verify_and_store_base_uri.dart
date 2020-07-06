import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../repositories/base_uri_repository.dart';

class VerifyAndStoreBaseUri {
  final BaseUriRepository repository;
  VerifyAndStoreBaseUri(this.repository);

  Future<Either<Failure, None>> call({
    @required String baseUri,
  }) async {
    return await repository.verifyAndStoreBaseUri(baseUri);
  }
}
