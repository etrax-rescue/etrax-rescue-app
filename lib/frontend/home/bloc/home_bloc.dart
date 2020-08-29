import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    @required this.clearMissionState,
    @required this.stopLocationUpdates,
    @required this.getLocationUpdateStream,
  })  : assert(clearMissionState != null),
        assert(stopLocationUpdates != null),
        assert(getLocationUpdateStream != null),
        super(HomeState.initial());

  final ClearMissionState clearMissionState;
  final StopLocationUpdates stopLocationUpdates;
  final GetLocationUpdateStream getLocationUpdateStream;

  StreamSubscription<LocationData> _streamSubscription;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is Startup) {
      if (event.userState.locationAccuracy != 0) {
        await _streamSubscription?.cancel();
        final getLocationUpdateStreamEither = await getLocationUpdateStream(
            GetLocationUpdateStreamParams(label: event.userState.name));

        yield* getLocationUpdateStreamEither.fold((failure) async* {},
            (locationStream) async* {
          _streamSubscription = locationStream.listen((locationData) =>
              add(LocationUpdate(locationData: locationData)));
        });
      }
    } else if (event is LocationUpdate) {
      yield HomeState.locationUpdate(locationData: event.locationData);
    } else if (event is LeaveMission) {
      final clearMissionStateEither = await clearMissionState(NoParams());
      yield* clearMissionStateEither.fold((failure) async* {
        // TODO: handle failure
      }, (_) async* {
        _streamSubscription?.cancel();
        _streamSubscription = null;
        final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());

        yield* stopLocationUpdatesEither.fold((failure) async* {
          // TODO: handle failure
        }, (stopped) async* {
          yield HomeState.closed();
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
