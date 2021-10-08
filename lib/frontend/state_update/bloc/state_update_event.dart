// @dart=2.9
part of 'state_update_bloc.dart';

abstract class StateUpdateEvent extends Equatable {
  const StateUpdateEvent();

  @override
  List<Object> get props => [];
}

class FetchStates extends StateUpdateEvent {}
