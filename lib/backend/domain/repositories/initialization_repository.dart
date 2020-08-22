import 'package:dartz/dartz.dart';

import '../../types/app_configuration.dart';
import '../../types/initialization_data.dart';
import '../../../core/error/failures.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/missions.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';

abstract class InitializationRepository {
  Future<Either<Failure, InitializationData>> fetchInitializationData(
      AppConnection appConnection, AuthenticationData authenticationData);

  Future<Either<Failure, MissionCollection>> getMissions();
  Future<Either<Failure, None>> clearMissions();

  Future<Either<Failure, AppConfiguration>> getAppConfiguration();
  Future<Either<Failure, None>> clearAppConfiguration();

  Future<Either<Failure, UserStateCollection>> getUserStates();
  Future<Either<Failure, None>> clearUserStates();

  Future<Either<Failure, UserRoleCollection>> getUserRoles();
  Future<Either<Failure, None>> clearUserRoles();
}
