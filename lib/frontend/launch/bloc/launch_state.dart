part of 'launch_bloc.dart';

abstract class LaunchState extends Equatable {
  const LaunchState();

  @override
  List<Object> get props => [];
}

class LaunchInitial extends LaunchState {}

class LaunchInProgress extends LaunchState {}

class LaunchAppConnectionPage extends LaunchState {}

class LaunchLoginPage extends LaunchState {
  final OrganizationCollection organizations;
  final String username;
  final String organizationID;
  LaunchLoginPage(
      {@required this.organizations,
      @required this.username,
      @required this.organizationID});

  @override
  List<Object> get props => [organizations, username, organizationID];
}

class LaunchMissionPage extends LaunchState {}

class LaunchHomePage extends LaunchState {
  final MissionState missionState;

  LaunchHomePage({@required this.missionState});

  @override
  List<Object> get props => [missionState];
}

class LaunchRecoverableError extends LaunchState {
  final String messageKey;

  LaunchRecoverableError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}

class LaunchUnecoverableError extends LaunchState {
  final String messageKey;

  LaunchUnecoverableError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
