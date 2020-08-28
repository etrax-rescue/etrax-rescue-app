part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LeaveMission extends HomeEvent {}

class Startup extends HomeEvent {}

class LocationUpdate extends HomeEvent {
  final LocationData locationData;
  LocationUpdate({@required this.locationData});

  @override
  List<Object> get props => [locationData];
}
