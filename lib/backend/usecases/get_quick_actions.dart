import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/initialization_repository.dart';
import '../types/quick_actions.dart';
import '../types/usecase.dart';

class GetQuickActions extends UseCase<QuickActionCollection, NoParams> {
  GetQuickActions(this.repository);

  final InitializationRepository repository;

  @override
  Future<Either<Failure, QuickActionCollection>> call(NoParams params) async {
    return await repository.getQuickActions();
  }
}
