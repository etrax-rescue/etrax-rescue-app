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
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/clear_location_cache.dart';
import '../../../backend/usecases/clear_mission_details.dart';
import '../../../backend/usecases/clear_mission_state.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_location_history.dart';
import '../../../backend/usecases/get_location_update_stream.dart';
import '../../../backend/usecases/get_mission_details.dart';
import '../../../backend/usecases/get_mission_state.dart';
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
    @required this.getMissionDetails,
    @required this.getLocationHistory,
    @required this.clearMissionState,
    @required this.clearLocationCache,
    @required this.stopLocationUpdates,
    @required this.clearMissionDetails,
    @required this.getLocationUpdateStream,
  })  : assert(getMissionState != null),
        assert(getAppConnection != null),
        assert(getAppConfiguration != null),
        assert(getAuthenticationData != null),
        assert(getMissionDetails != null),
        assert(getLocationHistory != null),
        assert(clearMissionState != null),
        assert(clearMissionDetails != null),
        assert(clearLocationCache != null),
        assert(stopLocationUpdates != null),
        assert(getLocationUpdateStream != null),
        super(HomeState.initial());

  final GetMissionState getMissionState;
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final GetMissionDetails getMissionDetails;
  final GetLocationUpdateStream getLocationUpdateStream;
  final GetLocationHistory getLocationHistory;
  final ClearLocationCache clearLocationCache;
  final ClearMissionState clearMissionState;
  final StopLocationUpdates stopLocationUpdates;
  final ClearMissionDetails clearMissionDetails;

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
    } else if (event is Shutdown) {
      yield* _shutdown(event);
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
          final getMissionStateEither = await getMissionState(NoParams());

          yield* getMissionStateEither.fold((failure) async* {
            // TODO: handle failure
          }, (missionState) async* {
            yield state.copyWith(
              appConnection: appConnection,
              authenticationData: authenticationData,
              appConfiguration: appConfiguration,
              missionState: missionState,
            );

            // Start the periodic updates of the mission details
            await _tickerSubscription?.cancel();
            _tickerSubscription = Stream.periodic(
                    Duration(minutes: appConfiguration.infoUpdateInterval))
                .listen((_) => add(UpdateMissionDetails()));

            final getLocationUpdateStreamEither = await getLocationUpdateStream(
                GetLocationUpdateStreamParams(
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
            add(LocationUpdate());
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
        print('failed to load details');
        print(failure);
      }, (missionDetailCollection) async* {
        yield state.copyWith(
            status: HomeStatus.ready,
            missionDetailCollection: missionDetailCollection);
      });
    }
  }

  Stream<HomeState> _shutdown(
    HomeEvent event,
  ) async* {
    final clearMissionStateEither = await clearMissionState(NoParams());
    yield* clearMissionStateEither.fold((failure) async* {
      // TODO: handle failure
    }, (_) async* {
      // cancel the stream subscription
      _streamSubscription?.cancel();
      _streamSubscription = null;

      final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());

      yield* stopLocationUpdatesEither.fold((failure) async* {
        // TODO: handle failure
      }, (stopped) async* {
        final clearLocationCacheEither = await clearLocationCache(NoParams());

        yield* clearLocationCacheEither.fold((failure) async* {
          // TODO: handle failure
        }, (_) async* {
          final clearMissionDetailsEither =
              await clearMissionDetails(NoParams());

          yield* clearMissionDetailsEither.fold((failure) async* {
            // TODO: handle failure
          }, (_) async* {
            yield HomeState.closed();
          });
        });
      });
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
