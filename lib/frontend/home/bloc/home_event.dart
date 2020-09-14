part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class Startup extends HomeEvent {
  const Startup({@required this.userState});

  final UserState userState;

  @override
  List<Object> get props => [userState];
}

class Refresh extends HomeEvent {}

class LocationUpdate extends HomeEvent {}

class UpdateMissionDetails extends HomeEvent {}

class Shutdown extends HomeEvent {}
