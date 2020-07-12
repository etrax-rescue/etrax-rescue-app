import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_connection.dart';

abstract class AppConnectionRepository {
  Future<Either<Failure, None>> verifyAndStoreAppConnection(String baseUri);
  Future<Either<Failure, AppConnection>> getAppConnection();
}
