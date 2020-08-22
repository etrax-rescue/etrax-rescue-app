import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../types/app_connection.dart';

abstract class AppConnectionRepository {
  Future<Either<Failure, None>> verifyAndStoreAppConnection(
      String authority, String basePath);
  Future<Either<Failure, AppConnection>> getAppConnection();
  Future<Either<Failure, bool>> getAppConnectionUpdateStatus();
  Future<Either<Failure, None>> markAppConnectionForUpdate();
}
