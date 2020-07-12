import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../repositories/app_connection_repository.dart';

class VerifyAndStoreAppConnection extends UseCase<None, AppConnectionParams> {
  final AppConnectionRepository repository;
  VerifyAndStoreAppConnection(this.repository);

  @override
  Future<Either<Failure, None>> call(AppConnectionParams param) async {
    return await repository.verifyAndStoreAppConnection(param.baseUri);
  }
}

class AppConnectionParams extends Equatable {
  final String baseUri;

  AppConnectionParams({@required this.baseUri});

  @override
  List<Object> get props => [baseUri];
}
