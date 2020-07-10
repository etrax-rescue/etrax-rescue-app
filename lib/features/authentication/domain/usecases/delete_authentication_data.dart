import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/repositories/authentication_repository.dart';

class DeleteAuthenticationData extends UseCase<None, NoParams> {
  final AuthenticationRepository repository;

  DeleteAuthenticationData(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.deleteAuthenticationData();
  }
}
