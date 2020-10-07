import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/app_connection.dart';
import '../../../backend/types/authentication_data.dart';
import '../../../backend/types/mission_details.dart';
import '../../../backend/types/mission_state.dart';
import '../../../backend/types/quick_actions.dart';
import '../../../backend/types/search_area.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/clear_location_cache.dart';
import '../../../backend/usecases/clear_mission_state.dart';
import '../../../backend/usecases/get_search_areas.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_location_history.dart';
import '../../../backend/usecases/get_location_update_stream.dart';
import '../../../backend/usecases/get_location_updates_status.dart';
import '../../../backend/usecases/get_mission_details.dart';
import '../../../backend/usecases/get_mission_state.dart';
import '../../../backend/usecases/get_quick_actions.dart';
import '../../../backend/usecases/stop_location_updates.dart';

part 'home_event.dart';
part 'home_state.dart';

const UI_REFRESH_INTERVAL_SECONDS = 30;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    @required this.getMissionState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
    @required this.getQuickActions,
    @required this.getMissionDetails,
    @required this.getSearchAreas,
    @required this.getLocationHistory,
    @required this.getLocationUpdatesStatus,
    @required this.clearMissionState,
    @required this.clearLocationCache,
    @required this.stopLocationUpdates,
    @required this.getLocationUpdateStream,
  })  : assert(getMissionState != null),
        assert(getAppConnection != null),
        assert(getAppConfiguration != null),
        assert(getAuthenticationData != null),
        assert(getQuickActions != null),
        assert(getMissionDetails != null),
        assert(getSearchAreas != null),
        assert(getLocationHistory != null),
        assert(getLocationUpdatesStatus != null),
        assert(clearMissionState != null),
        assert(clearLocationCache != null),
        assert(stopLocationUpdates != null),
        assert(getLocationUpdateStream != null),
        super(HomeState.initial());

  final GetMissionState getMissionState;
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final GetQuickActions getQuickActions;
  final GetMissionDetails getMissionDetails;
  final GetLocationUpdateStream getLocationUpdateStream;
  final GetLocationHistory getLocationHistory;
  final ClearLocationCache clearLocationCache;
  final ClearMissionState clearMissionState;
  final StopLocationUpdates stopLocationUpdates;
  final GetLocationUpdatesStatus getLocationUpdatesStatus;
  final GetSearchAreas getSearchAreas;

  StreamSubscription<LocationData> _streamSubscription;
  StreamSubscription<void> _tickerSubscription;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is Startup) {
      yield* _startup(event);
    } else if (event is LocationUpdate) {
      yield* _getLocationUpdate(event);
    } else if (event is UpdateMissionDetails) {
      yield* _updateMissionDetails(event);
    } else if (event is CheckStatus) {
      yield* _checkStatus(event);
    }
  }

  Stream<HomeState> _startup(
    HomeEvent event,
  ) async* {
    final appConnectionEither = await getAppConnection(NoParams());

    yield* appConnectionEither.fold((failure) async* {
      // TODO: handle failure
    }, (appConnection) async* {
      final authenticationDataEither = await getAuthenticationData(NoParams());

      yield* authenticationDataEither.fold((failure) async* {
        // TODO: handle failure
      }, (authenticationData) async* {
        final getAppConfigurationEither = await getAppConfiguration(NoParams());

        yield* getAppConfigurationEither.fold((failure) async* {
          // TODO: handle failure
        }, (appConfiguration) async* {
          final getQuickActionsEither = await getQuickActions(NoParams());

          yield* getQuickActionsEither.fold((failure) async* {
            // TODO: handle failure
          }, (quickActions) async* {
            final getMissionStateEither = await getMissionState(NoParams());

            yield* getMissionStateEither.fold((failure) async* {
              // TODO: handle failure
            }, (missionState) async* {
              yield state.copyWith(
                appConnection: appConnection,
                authenticationData: authenticationData,
                appConfiguration: appConfiguration,
                missionState: missionState,
                quickActions: quickActions,
              );

              // Start the periodic updates of the mission details
              await _tickerSubscription?.cancel();
              _tickerSubscription = Stream.periodic(
                      Duration(minutes: appConfiguration.infoUpdateInterval))
                  .listen((_) => add(UpdateMissionDetails()));

              final getLocationUpdateStreamEither =
                  await getLocationUpdateStream(GetLocationUpdateStreamParams(
                      label: missionState.mission.id.toString()));

              if (missionState.state.locationAccuracy > 0) {
                yield* getLocationUpdateStreamEither.fold((failure) async* {
                  // TODO: handle failure
                }, (locationStream) async* {
                  await _streamSubscription?.cancel();
                  _streamSubscription =
                      locationStream.listen((_) => add(LocationUpdate()));
                });
              }
              // Trigger an initial location update so that we can collect the
              // location history even if location updates are not active
              add(CheckStatus());
            });
          });
        });
      });
    });
  }

  Stream<HomeState> _getLocationUpdate(
    HomeEvent event,
  ) async* {
    final getLocationHistoryEither = await getLocationHistory(
        GetLocationHistoryParams(
            label: state.missionState.mission.id.toString()));

    yield* getLocationHistoryEither.fold((failure) async* {
      // TODO: handle failure
    }, (locationHistory) async* {
      yield state.copyWith(locationHistory: locationHistory);
    });
  }

  Stream<HomeState> _updateMissionDetails(
    HomeEvent event,
  ) async* {
    if (state.appConnection != null && state.authenticationData != null) {
      final getMissionDetailsEither = await getMissionDetails(
          GetMissionDetailsParams(
              appConnection: state.appConnection,
              authenticationData: state.authenticationData));

      yield* getMissionDetailsEither.fold((failure) async* {
        // TODO: handle failure
      }, (missionDetailCollection) async* {
        yield state.copyWith(missionDetailCollection: missionDetailCollection);
        final getSearchAreasEither = await getSearchAreas(GetSearchAreaParams(
            appConnection: state.appConnection,
            authenticationData: state.authenticationData));

        yield* getSearchAreasEither.fold((failure) async* {
          // TODO: handle failure
        }, (searchAreaCollection) async* {
          yield state.copyWith(
              status: HomeStatus.ready,
              searchAreaCollection: searchAreaCollection);
        });
      });
    }
  }

  Stream<HomeState> _checkStatus(
    HomeEvent event,
  ) async* {
    if (state.missionState.state.locationAccuracy > 0) {
      final locationUpdatesStatusEither =
          await getLocationUpdatesStatus(NoParams());
      yield* locationUpdatesStatusEither.fold((failure) async* {
        yield state.copyWith(renewStatus: true);
      }, (active) async* {
        if (!active) {
          yield state.copyWith(renewStatus: true);
        }
      });
    }
    // Trigger one location update even if the status doesn't require location
    // tracking so that the map view gets updated with the location history
    // from previous statuses.
    add(LocationUpdate());

    // Also update the mission details.
    add(UpdateMissionDetails());
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
