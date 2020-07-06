import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/link/domain/entities/base_uri.dart';

import '../../../../core/error/failures.dart';
import '../repositories/base_uri_repository.dart';

class GetBaseUri {
  final BaseUriRepository repository;
  GetBaseUri(this.repository);

  Future<Either<Failure, BaseUri>> call() async {
    return await repository.getBaseUri();
  }
}
