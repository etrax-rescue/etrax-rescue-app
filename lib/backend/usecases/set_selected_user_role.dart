import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/usecase.dart';
import '../types/user_roles.dart';

class SetSelectedUserRole extends UseCase<None, SetSelectedUserRoleParams> {
  final AppStateRepository repository;
  SetSelectedUserRole(this.repository);

  @override
  Future<Either<Failure, None>> call(SetSelectedUserRoleParams param) async {
    return await repository.setSelectedUserRole(param.role);
  }
}

class SetSelectedUserRoleParams extends Equatable {
  final UserRole role;

  SetSelectedUserRoleParams({@required this.role});

  @override
  List<Object> get props => [role];
}
