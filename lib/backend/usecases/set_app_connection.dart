import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../types/usecase.dart';
import '../repositories/app_state_repository.dart';

class VerifyAndStoreAppConnection extends UseCase<None, AppConnectionParams> {
  final AppStateRepository repository;
  VerifyAndStoreAppConnection(this.repository);

  @override
  Future<Either<Failure, None>> call(AppConnectionParams param) async {
    return await repository.setAppConnection(param.authority, param.basePath);
  }
}

class AppConnectionParams extends Equatable {
  final String authority;
  final String basePath;

  AppConnectionParams({@required this.authority, @required this.basePath});

  @override
  List<Object> get props => [authority, basePath];
}
