// @dart=2.9
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/poi_repository.dart';
import '../types/poi.dart';
import '../types/usecase.dart';

class CapturePoi extends UseCase<Poi, NoParams> {
  CapturePoi(this.repository);

  final PoiRepository repository;

  @override
  Future<Either<Failure, Poi>> call(NoParams params) async {
    return await repository.capture();
  }
}
