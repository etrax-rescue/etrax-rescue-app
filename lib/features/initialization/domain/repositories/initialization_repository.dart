import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/mission.dart';
import '../entities/app_settings.dart';

abstract class InitializationRepository {
  Future<Either<Failure, None>> login(
      String baseUri, String username, String password);

  Future<Either<Failure, List<Mission>>> getMissions();

  Future<Either<Failure, AppSettings>> getAppSettings();

  Future<Either<Failure, None>> fetchInitializationData(
      String baseUri, String username, String token);
}
