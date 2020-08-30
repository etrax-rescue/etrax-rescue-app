import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/mission_state.dart';
import 'package:etrax_rescue_app/backend/usecases/clear_location_cache.dart';
import 'package:etrax_rescue_app/backend/usecases/get_location_history.dart';
import 'package:etrax_rescue_app/backend/usecases/get_mission_state.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/clear_mission_state.dart';
import '../../../backend/usecases/get_location_update_stream.dart';
import '../../../backend/usecases/stop_location_updates.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    @required this.getMissionState,
    @required this.getLocationHistory,
    @required this.clearMissionState,
    @required this.clearLocationCache,
    @required this.stopLocationUpdates,
    @required this.getLocationUpdateStream,
  })  : assert(getMissionState != null),
        assert(getLocationHistory != null),
        assert(clearMissionState != null),
        assert(clearLocationCache != null),
        assert(stopLocationUpdates != null),
        assert(getLocationUpdateStream != null),
        super(HomeState.initial());

  final GetMissionState getMissionState;
  final GetLocationUpdateStream getLocationUpdateStream;
  final GetLocationHistory getLocationHistory;
  final ClearLocationCache clearLocationCache;
  final ClearMissionState clearMissionState;
  final StopLocationUpdates stopLocationUpdates;

  StreamSubscription<LocationData> _streamSubscription;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is Startup) {
      final getMissionStateEither = await getMissionState(NoParams());

      yield* getMissionStateEither.fold((failure) async* {
        // TODO: handle failure
      }, (missionState) async* {
        if (missionState.state.locationAccuracy != 0) {
          await _streamSubscription?.cancel();
          final getLocationUpdateStreamEither = await getLocationUpdateStream(
              GetLocationUpdateStreamParams(
                  label: missionState.mission.id.toString()));

          yield state.copyWith(missionState: missionState);

          yield* getLocationUpdateStreamEither.fold((failure) async* {},
              (locationStream) async* {
            _streamSubscription =
                locationStream.listen((_) => add(LocationUpdate()));
          });
        }
      });
    } else if (event is LocationUpdate) {
      final getLocationHistoryEither = await getLocationHistory(
          GetLocationHistoryParams(
              label: state.missionState.mission.id.toString()));
      yield* getLocationHistoryEither.fold((failure) async* {
        // TODO: handle failure
      }, (locationHistory) async* {
        yield state.copyWith(locationHistory: locationHistory);
      });
    } else if (event is LeaveMission) {
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
            yield HomeState.closed();
          });
        });
      });
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
