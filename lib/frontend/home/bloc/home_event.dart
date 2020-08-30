part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LeaveMission extends HomeEvent {}

class Startup extends HomeEvent {
  const Startup({@required this.userState});

  final UserState userState;

  @override
  List<Object> get props => [userState];
}

class LocationUpdate extends HomeEvent {}
