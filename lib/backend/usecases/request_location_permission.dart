import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class RequestLocationPermission extends UseCase<PermissionStatus, NoParams> {
  final LocationRepository repository;
  RequestLocationPermission(this.repository);

  @override
  Future<Either<Failure, PermissionStatus>> call(NoParams params) async {
    return await repository.requestPermission();
  }
}
