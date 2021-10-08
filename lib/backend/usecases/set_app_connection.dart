import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../repositories/app_connection_repository.dart';
import '../types/usecase.dart';

class SetAppConnection extends UseCase<None, AppConnectionParams> {
  SetAppConnection(this.repository);

  final AppConnectionRepository repository;

  @override
  Future<Either<Failure, None>> call(AppConnectionParams param) async {
    return await repository.setAppConnection(param.authority, param.basePath);
  }
}

class AppConnectionParams extends Equatable {
  AppConnectionParams({required this.authority, required this.basePath});

  final String authority;
  final String basePath;

  @override
  List<Object> get props => [authority, basePath];
}
