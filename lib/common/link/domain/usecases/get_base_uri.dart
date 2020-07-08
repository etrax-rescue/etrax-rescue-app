import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/base_uri.dart';
import '../repositories/base_uri_repository.dart';

class GetBaseUri {
  final BaseUriRepository repository;
  GetBaseUri(this.repository);

  Future<Either<Failure, BaseUri>> call() async {
    return await repository.getBaseUri();
  }
}
