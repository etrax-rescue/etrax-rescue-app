import 'package:dartz/dartz.dart';

import '../../../backend/domain/entities/app_settings.dart';
import '../../../backend/domain/entities/initialization_data.dart';
import '../../../core/error/failures.dart';
import '../../../core/types/app_connection.dart';
import '../../../core/types/authentication_data.dart';
import '../../domain/entities/missions.dart';
import '../../domain/entities/user_roles.dart';
import '../../domain/entities/user_states.dart';

abstract class InitializationRepository {
  Future<Either<Failure, InitializationData>> fetchInitializationData(
      AppConnection appConnection, AuthenticationData authenticationData);

  Future<Either<Failure, MissionCollection>> getMissions();
  Future<Either<Failure, None>> clearMissions();

  Future<Either<Failure, AppSettings>> getAppSettings();
  Future<Either<Failure, None>> clearAppSettings();

  Future<Either<Failure, UserStateCollection>> getUserStates();
  Future<Either<Failure, None>> clearUserStates();

  Future<Either<Failure, UserRoleCollection>> getUserRoles();
  Future<Either<Failure, None>> clearUserRoles();
}
