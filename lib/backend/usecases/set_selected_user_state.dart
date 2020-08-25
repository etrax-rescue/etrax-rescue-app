import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/app_state_repository.dart';
import '../types/usecase.dart';
import '../types/user_states.dart';

class SetSelectedUserState extends UseCase<None, SetSelectedUserStateParams> {
  final AppStateRepository repository;
  SetSelectedUserState(this.repository);

  @override
  Future<Either<Failure, None>> call(SetSelectedUserStateParams param) async {
    return await repository.setSelectedUserState(param.state);
  }
}

class SetSelectedUserStateParams extends Equatable {
  final UserState state;

  SetSelectedUserStateParams({@required this.state});

  @override
  List<Object> get props => [state];
}
