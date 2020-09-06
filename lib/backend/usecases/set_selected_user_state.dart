import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_state_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';
import '../types/user_states.dart';

class SetSelectedUserState extends UseCase<None, SetSelectedUserStateParams> {
  final MissionStateRepository repository;
  SetSelectedUserState(this.repository);

  @override
  Future<Either<Failure, None>> call(SetSelectedUserStateParams param) async {
    return await repository.setSelectedUserState(
        param.appConnection, param.authenticationData, param.state);
  }
}

class SetSelectedUserStateParams extends Equatable {
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final UserState state;

  SetSelectedUserStateParams({
    @required this.appConnection,
    @required this.authenticationData,
    @required this.state,
  });

  @override
  List<Object> get props => [state];
}
