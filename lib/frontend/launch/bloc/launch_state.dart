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
  final String missionID;
  LaunchLoginPage(
      {@required this.organizations,
      @required this.username,
      @required this.missionID});

  @override
  List<Object> get props => [organizations, username, missionID];
}

class LaunchMissionPage extends LaunchState {}

class LaunchHomePage extends LaunchState {
  final MissionState missionState;
  final AppConfiguration appConfiguration;

  LaunchHomePage(
      {@required this.missionState, @required this.appConfiguration});

  @override
  List<Object> get props => [missionState, appConfiguration];
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
