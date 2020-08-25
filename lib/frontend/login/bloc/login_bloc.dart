import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_organizations.dart';
import '../../../backend/usecases/login.dart';
import '../../../backend/usecases/delete_app_connection.dart';
import '../../../backend/types/organizations.dart';
import '../../../core/error/failures.dart';
import '../../../backend/types/usecase.dart';
import '../../util/translate_error_messages.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final DeleteAppConnection deleteAppConnection;
  LoginBloc(
      {@required this.login,
      @required this.getAppConnection,
      @required this.getOrganizations,
      @required this.deleteAppConnection})
      : assert(login != null),
        assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(deleteAppConnection != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield LoginInProgress();
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final loginEither = await login(LoginParams(
          appConnection: appConnection,
          organizationID: event.organizationID,
          username: event.username,
          password: event.password,
        ));
        yield* loginEither.fold((failure) async* {
          yield LoginError(messageKey: _mapFailureToMessage(failure));
        }, (_) async* {
          yield LoginSuccess();
        });
      });
    } else if (event is RequestAppConnectionUpdate) {
      final markEither = await deleteAppConnection(NoParams());
      yield* markEither.fold((failure) async* {
        yield LoginError(messageKey: _mapFailureToMessage(failure));
      }, (_) async* {
        yield RequestedAppConnectionUpdate();
      });
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE_KEY;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE_KEY;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE_KEY;
    case LoginFailure:
      return LOGIN_FAILURE_MESSAGE_KEY;
    default:
      return UNEXPECTED_FAILURE_MESSAGE_KEY;
  }
}
