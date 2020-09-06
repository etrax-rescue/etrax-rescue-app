import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/types/poi.dart';

import '../../core/error/failures.dart';
import '../repositories/poi_repository.dart';
import '../types/usecase.dart';

class CapturePoi extends UseCase<Poi, NoParams> {
  final PoiRepository repository;
  CapturePoi(this.repository);

  @override
  Future<Either<Failure, Poi>> call(NoParams params) async {
    return await repository.capture();
  }
}
