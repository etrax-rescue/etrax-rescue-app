import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/mission_state_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/usecase.dart';
import '../types/user_states.dart';

class TriggerQuickAction extends UseCase<None, TriggerQuickActionParams> {
  TriggerQuickAction(this.repository);

  final MissionStateRepository repository;

  @override
  Future<Either<Failure, None>> call(TriggerQuickActionParams param) async {
    return await repository.triggerQuickAction(param.appConnection,
        param.authenticationData, param.action, param.currentLocation);
  }
}

class TriggerQuickActionParams extends Equatable {
  TriggerQuickActionParams({
    @required this.appConnection,
    @required this.authenticationData,
    @required this.action,
    @required this.currentLocation,
  });

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final UserState action;
  final LocationData currentLocation;

  @override
  List<Object> get props =>
      [action, appConnection, authenticationData, currentLocation];
}
