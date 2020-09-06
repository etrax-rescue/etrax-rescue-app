import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_state_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';
import '../types/user_roles.dart';

class SetSelectedUserRole extends UseCase<None, SetSelectedUserRoleParams> {
  final MissionStateRepository repository;
  SetSelectedUserRole(this.repository);

  @override
  Future<Either<Failure, None>> call(SetSelectedUserRoleParams param) async {
    return await repository.setSelectedUserRole(
        param.appConnection, param.authenticationData, param.role);
  }
}

class SetSelectedUserRoleParams extends Equatable {
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final UserRole role;

  SetSelectedUserRoleParams({
    @required this.appConnection,
    @required this.authenticationData,
    @required this.role,
  });

  @override
  List<Object> get props => [role];
}
