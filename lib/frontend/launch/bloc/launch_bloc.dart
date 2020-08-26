import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/mission_state.dart';
import '../../../backend/types/organizations.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_mission_state.dart';
import '../../../backend/usecases/get_organizations.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'launch_event.dart';
part 'launch_state.dart';

class LaunchBloc extends Bloc<LaunchEvent, LaunchState> {
  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final GetAuthenticationData getAuthenticationData;
  final GetMissionState getMissionState;
  final GetAppConfiguration getAppConfiguration;
  LaunchBloc({
    @required this.getAppConnection,
    @required this.getOrganizations,
    @required this.getAuthenticationData,
    @required this.getMissionState,
    @required this.getAppConfiguration,
  })  : assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(getAuthenticationData != null),
        assert(getMissionState != null),
        assert(getAppConfiguration != null),
        super(LaunchInitial());

  @override
  Stream<LaunchState> mapEventToState(
    LaunchEvent event,
  ) async* {
    if (event is Launch) {
      yield LaunchInProgress();
      final appConnectionEither = await getAppConnection(NoParams());
      yield* appConnectionEither.fold((failure) async* {
        yield LaunchAppConnectionPage();
      }, (appConnection) async* {
        final organizationsEither = await getOrganizations(
            GetOrganizationsParams(appConnection: appConnection));

        yield* organizationsEither.fold((failure) async* {
          yield LaunchRecoverableError(
              messageKey: _mapFailureToMessage(failure));
        }, (organizations) async* {
          final authenticationDataEither =
              await getAuthenticationData(NoParams());

          yield* authenticationDataEither.fold((failure) async* {
            yield LaunchLoginPage(
              organizations: organizations,
              username: null,
              organizationID: null,
            );
          }, (authenticationData) async* {
            if (authenticationData.token != '') {
              // TODO: add logic for checking if mission is active
              final missionStateEither = await getMissionState(NoParams());
              yield* missionStateEither.fold((failure) async* {
                // If there is no mission state, there is probably no mission as well
                yield LaunchLoginPage(
                  organizations: organizations,
                  username: authenticationData.username,
                  organizationID: authenticationData.organizationID,
                );
              }, (missionState) async* {
                final appConfigurationEither =
                    await getAppConfiguration(NoParams());
                yield* appConfigurationEither.fold((failure) async* {
                  yield LaunchRecoverableError(
                      messageKey: _mapFailureToMessage(failure));
                }, (appConfiguration) async* {
                  yield LaunchHomePage(
                      missionState: missionState,
                      appConfiguration: appConfiguration);
                });
              });
            } else {
              yield LaunchLoginPage(
                organizations: organizations,
                username: authenticationData.username,
                organizationID: authenticationData.organizationID,
              );
            }
          });
        });
      });
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
}
