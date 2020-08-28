part of 'state_update_bloc.dart';

abstract class StateUpdateState extends Equatable {
  const StateUpdateState();

  @override
  List<Object> get props => [];
}

class StateUpdateInitial extends StateUpdateState {}

class FetchingStatesInProgress extends StateUpdateState {}

class FetchingStatesSuccess extends StateUpdateState {
  final UserStateCollection states;
  FetchingStatesSuccess({@required this.states});

  @override
  List<Object> get props => [states];
}
