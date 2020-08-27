part of 'update_state_cubit.dart';

enum SequencePosition {
  initial,
  settings,
  locationPermission,
  locationServices,
  setState,
}

abstract class UpdateStateState extends Equatable {
  final SequencePosition sequencePosition;
  const UpdateStateState(this.sequencePosition);

  bool operator <(UpdateStateState other) {
    return sequencePosition.index < other.sequencePosition.index;
  }

  bool operator >(UpdateStateState other) {
    return sequencePosition.index > other.sequencePosition.index;
  }

  @override
  List<Object> get props => [sequencePosition.index];
}

class UpdateStateInitial extends UpdateStateState {
  UpdateStateInitial() : super(SequencePosition.initial);
}

// Settings
class RetrievingSettingsState extends UpdateStateState {
  RetrievingSettingsState() : super(SequencePosition.settings);
}

class RetrievingSettingsInProgress extends RetrievingSettingsState {}

class RetrievingSettingsSuccess extends RetrievingSettingsState {}

// Location Permission States
class LocationPermissionState extends UpdateStateState {
  LocationPermissionState() : super(SequencePosition.locationPermission);
}

class LocationPermissionInProgress extends LocationPermissionState {}

class LocationPermissionResult extends LocationPermissionState {
  final PermissionStatus permissionStatus;
  LocationPermissionResult({@required this.permissionStatus}) : super();
}

// Location Services States
class LocationServicesState extends UpdateStateState {
  LocationServicesState() : super(SequencePosition.locationServices);
}

class LocationServicesInProgress extends LocationServicesState {}

class LocationServicesResult extends LocationServicesState {
  final bool enabled;
  LocationServicesResult({@required this.enabled}) : super();
}

// Update State States
class SetStateState extends UpdateStateState {
  SetStateState() : super(SequencePosition.setState);
}

class UpdateStateInProgress extends SetStateState {}

class UpdateStateSuccess extends SetStateState {}

class UpdateStateError extends SetStateState {
  final String messageKey;
  UpdateStateError({@required this.messageKey}) : super();

  @override
  List<Object> get props => [messageKey];
}
