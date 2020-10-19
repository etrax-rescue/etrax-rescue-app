import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/mission_state.dart';
import '../../../backend/types/organizations.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_mission_state.dart';
import '../../../backend/usecases/get_organizations.dart';
import '../../util/translate_error_messages.dart';

part 'launch_event.dart';
part 'launch_state.dart';

class LaunchBloc extends Bloc<LaunchEvent, LaunchState> {
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

  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final GetAuthenticationData getAuthenticationData;
  final GetMissionState getMissionState;
  final GetAppConfiguration getAppConfiguration;

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
              messageKey: mapFailureToMessageKey(failure));
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
              final missionStateEither = await getMissionState(NoParams());
              yield* missionStateEither.fold((failure) async* {
                // If there is no mission state, there is probably no mission as well
                yield LaunchLoginPage(
                  organizations: organizations,
                  username: authenticationData.username,
                  organizationID: authenticationData.organizationID,
                );
              }, (missionState) async* {
                yield LaunchHomePage(missionState: missionState);
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
}
