import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/usecases/stop_location_updates.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/clear_mission_state.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ClearMissionState clearMissionState;
  final StopLocationUpdates stopLocationUpdates;

  StreamSubscription<LocationData> _streamSubscription;

  HomeBloc(
      {@required this.clearMissionState, @required this.stopLocationUpdates})
      : assert(clearMissionState != null),
        assert(stopLocationUpdates != null),
        super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is Startup) {
    } else if (event is LeaveMission) {
      final clearMissionStateEither = await clearMissionState(NoParams());
      yield* clearMissionStateEither.fold((failure) async* {
        // TODO: handle failure
      }, (_) async* {
        final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());

        yield* stopLocationUpdatesEither.fold((failure) async* {
          // TODO: handle failure
        }, (stopped) async* {
          yield LeftMission();
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
