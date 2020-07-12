import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../entities/missions.dart';
import '../entities/user_roles.dart';
import '../entities/user_states.dart';

abstract class InitializationRepository {
  Future<Either<Failure, None>> fetchInitializationData(
      String baseUri, String username, String token);

  Future<Either<Failure, Missions>> getMissions();
  Future<Either<Failure, None>> clearMissions();

  Future<Either<Failure, AppSettings>> getAppSettings();
  Future<Either<Failure, None>> clearAppSettings();

  Future<Either<Failure, UserStates>> getUserStates();
  Future<Either<Failure, None>> clearUserStates();

  Future<Either<Failure, UserRoles>> getUserRoles();
  Future<Either<Failure, None>> clearUserRoles();
}
