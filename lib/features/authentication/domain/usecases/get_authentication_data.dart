import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:etrax_rescue_app/features/authentication/domain/repositories/authentication_repository.dart';

class GetAuthenticationData extends UseCase<AuthenticationData, NoParams> {
  final AuthenticationRepository repository;

  GetAuthenticationData(this.repository);

  @override
  Future<Either<Failure, AuthenticationData>> call(NoParams params) async {
    return await repository.getAuthenticationData();
  }
}
