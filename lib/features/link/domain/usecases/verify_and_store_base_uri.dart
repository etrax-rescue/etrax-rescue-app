import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../repositories/base_uri_repository.dart';

class VerifyAndStoreBaseUri extends UseCase<None, BaseUriParams> {
  final BaseUriRepository repository;
  VerifyAndStoreBaseUri(this.repository);

  @override
  Future<Either<Failure, None>> call(BaseUriParams param) async {
    return await repository.verifyAndStoreBaseUri(param.baseUri);
  }
}

class BaseUriParams extends Equatable {
  final String baseUri;

  BaseUriParams({@required this.baseUri});

  @override
  List<Object> get props => [baseUri];
}
