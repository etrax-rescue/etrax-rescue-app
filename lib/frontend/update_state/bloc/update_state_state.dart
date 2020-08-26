part of 'update_state_bloc.dart';

abstract class UpdateStateState extends Equatable {
  const UpdateStateState();

  @override
  List<Object> get props => [];
}

class UpdateStateInitial extends UpdateStateState {}

class CheckingPermissionInProgress extends UpdateStateState {}

class LocationPermissionDenied extends UpdateStateState {}

class LocationPermissionDeniedForever extends UpdateStateState {}

class LocationPermissionGranted extends UpdateStateState {}

class CheckingLocationServicesInProgress extends UpdateStateState {}

class LocationServicesEnabled extends UpdateStateState {}

class LocationServicesDisabled extends UpdateStateState {}

class UpdateStateInProgress extends UpdateStateState {}

class UpdateStateSuccess extends UpdateStateState {}

class UpdateStateError extends UpdateStateState {
  final String messageKey;
  UpdateStateError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
