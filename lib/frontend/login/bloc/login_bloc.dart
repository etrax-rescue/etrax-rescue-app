import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/organizations.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/delete_app_connection.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_organizations.dart';
import '../../../backend/usecases/login.dart';
import '../../util/translate_error_messages.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required this.login,
    @required this.getAppConnection,
    @required this.getOrganizations,
    @required this.getAuthenticationData,
    @required this.deleteAppConnection,
  })  : assert(login != null),
        assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(deleteAppConnection != null),
        super(LoginInitial());

  final Login login;
  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final GetAuthenticationData getAuthenticationData;
  final DeleteAppConnection deleteAppConnection;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is InitializeLogin) {
      final appConnectionEither = await getAppConnection(NoParams());
      yield* appConnectionEither.fold((failure) async* {
        yield OpenAppConnectionPage();
      }, (appConnection) async* {
        final organizationsEither = await getOrganizations(
            GetOrganizationsParams(appConnection: appConnection));

        yield* organizationsEither.fold((failure) async* {
          yield LoginInitializationError(
              messageKey: mapFailureToMessageKey(failure));
        }, (organizations) async* {
          final authenticationDataEither =
              await getAuthenticationData(NoParams());

          yield* authenticationDataEither.fold((failure) async* {
            yield LoginReady(
                organizations: organizations,
                username: null,
                organizationID: null);
          }, (authenticationData) async* {
            yield LoginReady(
                organizations: organizations,
                username: authenticationData.username,
                organizationID: authenticationData.organizationID);
          });
        });
      });
    }
    if (event is SubmitLogin) {
      yield LoginInProgress(
        organizations: state.organizations,
        username: event.username,
        organizationID: event.organizationID,
      );
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(
            organizations: state.organizations,
            username: state.username,
            organizationID: state.organizationID,
            messageKey: FailureMessageKey.cache);
      }, (appConnection) async* {
        final loginEither = await login(LoginParams(
          appConnection: appConnection,
          organizationID: event.organizationID,
          username: event.username,
          password: event.password,
        ));
        yield* loginEither.fold((failure) async* {
          yield LoginError(
              organizations: state.organizations,
              username: state.username,
              organizationID: state.organizationID,
              messageKey: mapFailureToMessageKey(failure));
        }, (_) async* {
          yield LoginSuccess();
        });
      });
    } else if (event is RequestAppConnectionUpdate) {
      final markEither = await deleteAppConnection(NoParams());
      yield* markEither.fold((failure) async* {
        yield LoginError(
            organizations: state.organizations,
            username: state.username,
            organizationID: state.organizationID,
            messageKey: mapFailureToMessageKey(failure));
      }, (_) async* {
        yield OpenAppConnectionPage();
      });
    }
  }
}
