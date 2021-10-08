// @dart=2.9
import 'package:background_location/background_location.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/location_repository.dart';
import '../types/usecase.dart';

class GetLastLocation extends UseCase<LocationData, NoParams> {
  GetLastLocation(this.repository);

  final LocationRepository repository;

  @override
  Future<Either<Failure, LocationData>> call(NoParams params) async {
    return await repository.getLastLocation();
  }
}
