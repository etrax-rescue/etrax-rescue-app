import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_state_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/missions.dart';
import '../types/usecase.dart';

class SetSelectedMission extends UseCase<None, SetSelectedMissionParams> {
  SetSelectedMission(this.repository);

  final MissionStateRepository repository;

  @override
  Future<Either<Failure, None>> call(SetSelectedMissionParams param) async {
    return await repository.setSelectedMission(
        param.appConnection, param.authenticationData, param.mission);
  }
}

class SetSelectedMissionParams extends Equatable {
  SetSelectedMissionParams({
    required this.appConnection,
    required this.authenticationData,
    required this.mission,
  });

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final Mission mission;

  @override
  List<Object> get props => [mission];
}
