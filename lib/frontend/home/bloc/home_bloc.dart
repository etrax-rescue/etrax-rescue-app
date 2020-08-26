import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/clear_mission_state.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ClearMissionState clearMissionState;
  HomeBloc({@required this.clearMissionState})
      : assert(clearMissionState != null),
        super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LeaveMission) {
      final clearMissionStateEither = await clearMissionState(NoParams());
      yield* clearMissionStateEither.fold((failure) async* {},
          (authority) async* {
        yield LeftMission();
      });
    }
  }
}
