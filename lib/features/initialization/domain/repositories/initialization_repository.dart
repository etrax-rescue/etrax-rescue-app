import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';

import '../../../../core/error/failures.dart';
import '../entities/missions.dart';
import '../entities/app_settings.dart';

abstract class InitializationRepository {
  Future<Either<Failure, None>> login(
      String baseUri, String username, String password);

  Future<Either<Failure, None>> fetchInitializationData(
      String baseUri, String username, String token);

  Future<Either<Failure, Missions>> getMissions();

  Future<Either<Failure, AppSettings>> getAppSettings();

  Future<Either<Failure, UserStates>> getUserStates();
}
