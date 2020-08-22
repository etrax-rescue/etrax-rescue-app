import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/domain/usecases/get_app_connection.dart';
import '../../../backend/domain/usecases/get_organizations.dart';
import '../../../backend/domain/usecases/login.dart';
import '../../../backend/domain/usecases/mark_app_connection_for_update.dart';
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
  final MarkAppConnectionForUpdate markAppConnectionForUpdate;
  LoginBloc(
      {@required this.login,
      @required this.getAppConnection,
      @required this.getOrganizations,
      @required this.markAppConnectionForUpdate})
      : assert(login != null),
        assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(markAppConnectionForUpdate != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is InitializeLogin) {
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final organizationsEither = await getOrganizations(
            GetOrganizationsParams(appConnection: appConnection));

        yield* organizationsEither.fold((failure) async* {},
            (organizations) async* {
          yield LoginReady(organizationCollection: organizations);
        });
      });
    } else if (event is SubmitLogin) {
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
      final markEither = await markAppConnectionForUpdate(NoParams());
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
