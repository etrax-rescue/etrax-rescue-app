import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/missions.dart';
import '../types/usecase.dart';

class SetSelectedMission extends UseCase<None, SetSelectedMissionParams> {
  final AppStateRepository repository;
  SetSelectedMission(this.repository);

  @override
  Future<Either<Failure, None>> call(SetSelectedMissionParams param) async {
    return await repository.setSelectedMission(
        param.appConnection, param.authenticationData, param.mission);
  }
}

class SetSelectedMissionParams extends Equatable {
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final Mission mission;

  SetSelectedMissionParams({
    @required this.appConnection,
    @required this.authenticationData,
    @required this.mission,
  });

  @override
  List<Object> get props => [mission];
}
