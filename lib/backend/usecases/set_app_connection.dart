import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/app_connection_repository.dart';
import '../types/usecase.dart';

class SetAppConnection extends UseCase<None, AppConnectionParams> {
  final AppConnectionRepository repository;
  SetAppConnection(this.repository);

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
