import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/poi_repository.dart';
import '../types/usecase.dart';

class TakePhoto extends UseCase<String, NoParams> {
  final PoiRepository repository;
  TakePhoto(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.takePhoto();
  }
}
