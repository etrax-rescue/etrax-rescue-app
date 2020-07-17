import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/app_connection.dart';
import '../entities/app_settings.dart';
import '../entities/missions.dart';
import '../entities/user_roles.dart';
import '../entities/user_states.dart';

abstract class InitializationRepository {
  Future<Either<Failure, MissionCollection>> fetchInitializationData(
      AppConnection appConnection, String username, String token);

  Future<Either<Failure, MissionCollection>> getMissions();
  Future<Either<Failure, None>> clearMissions();

  Future<Either<Failure, AppSettings>> getAppSettings();
  Future<Either<Failure, None>> clearAppSettings();

  Future<Either<Failure, UserStateCollection>> getUserStates();
  Future<Either<Failure, None>> clearUserStates();

  Future<Either<Failure, UserRoleCollection>> getUserRoles();
  Future<Either<Failure, None>> clearUserRoles();
}
