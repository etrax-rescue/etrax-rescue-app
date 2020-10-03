import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/get_user_states.dart';

part 'state_update_event.dart';
part 'state_update_state.dart';

class StateUpdateBloc extends Bloc<StateUpdateEvent, StateUpdateState> {
  StateUpdateBloc({@required this.getUserStates})
      : assert(getUserStates != null),
        super(StateUpdateInitial());

  final GetUserStates getUserStates;

  @override
  Stream<StateUpdateState> mapEventToState(
    StateUpdateEvent event,
  ) async* {
    if (event is FetchStates) {
      yield FetchingStatesInProgress();
      final getUserStatesEither = await getUserStates(NoParams());

      yield* getUserStatesEither.fold((failure) async* {
        // TODO: handle failure
      }, (userStates) async* {
        yield FetchingStatesSuccess(states: userStates);
      });
    }
  }
}
