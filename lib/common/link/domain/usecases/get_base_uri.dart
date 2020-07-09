import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/base_uri.dart';
import '../repositories/base_uri_repository.dart';

class GetBaseUri extends UseCase<BaseUri, NoParams> {
  final BaseUriRepository repository;
  GetBaseUri(this.repository);

  @override
  Future<Either<Failure, BaseUri>> call(NoParams params) async {
    return await repository.getBaseUri();
  }
}
