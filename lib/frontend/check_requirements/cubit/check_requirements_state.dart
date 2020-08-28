part of 'check_requirements_cubit.dart';

enum SequencePosition {
  initial,
  settings,
  locationPermission,
  locationServices,
  setState,
  stopUpdates,
  startUpdates,
  success,
}

abstract class CheckRequirementsState extends Equatable {
  final SequencePosition sequencePosition;
  const CheckRequirementsState(this.sequencePosition);

  bool operator <(CheckRequirementsState other) {
    return sequencePosition.index < other.sequencePosition.index;
  }

  bool operator >(CheckRequirementsState other) {
    return sequencePosition.index > other.sequencePosition.index;
  }

  @override
  List<Object> get props => [sequencePosition.index];
}

class UpdateStateInitial extends CheckRequirementsState {
  UpdateStateInitial() : super(SequencePosition.initial);
}

// Settings
class RetrievingSettingsState extends CheckRequirementsState {
  RetrievingSettingsState() : super(SequencePosition.settings);
}

class RetrievingSettingsInProgress extends RetrievingSettingsState {}

class RetrievingSettingsSuccess extends RetrievingSettingsState {}

// Location Permission States
class LocationPermissionState extends CheckRequirementsState {
  LocationPermissionState() : super(SequencePosition.locationPermission);
}

class LocationPermissionInProgress extends LocationPermissionState {}

class LocationPermissionResult extends LocationPermissionState {
  final PermissionStatus permissionStatus;
  LocationPermissionResult({@required this.permissionStatus}) : super();
}

// Location Services States
class LocationServicesState extends CheckRequirementsState {
  LocationServicesState() : super(SequencePosition.locationServices);
}

class LocationServicesInProgress extends LocationServicesState {}

class LocationServicesResult extends LocationServicesState {
  final bool enabled;
  LocationServicesResult({@required this.enabled}) : super();
}

class LocationServicesError extends LocationServicesState {
  final String messageKey;
  LocationServicesError({@required this.messageKey}) : super();
}

// Update State States
class SetStateState extends CheckRequirementsState {
  SetStateState() : super(SequencePosition.setState);
}

class SetStateInProgress extends SetStateState {}

class SetStateSuccess extends SetStateState {}

class SetStateError extends SetStateState {
  final String messageKey;
  SetStateError({@required this.messageKey}) : super();

  @override
  List<Object> get props => [messageKey];
}

// Stop Updates States
class StopUpdatesState extends CheckRequirementsState {
  StopUpdatesState() : super(SequencePosition.stopUpdates);
}

class StopUpdatesInProgress extends StopUpdatesState {}

class StopUpdatesSuccess extends StopUpdatesState {}

// Start Updates States
class StartUpdatesState extends CheckRequirementsState {
  StartUpdatesState() : super(SequencePosition.startUpdates);
}

class StartUpdatesInProgress extends StartUpdatesState {}

class StartUpdatesSuccess extends StartUpdatesState {}

// Error and Success
class CheckRequirementsError extends SetStateState {
  final String messageKey;
  CheckRequirementsError({@required this.messageKey}) : super();

  @override
  List<Object> get props => [messageKey];
}

class CheckRequirementsSuccess extends CheckRequirementsState {
  CheckRequirementsSuccess() : super(SequencePosition.success);
}
