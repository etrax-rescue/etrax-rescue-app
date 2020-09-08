part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState({
    @required this.organizations,
    @required this.username,
    @required this.organizationID,
  });

  final OrganizationCollection organizations;
  final String username;
  final String organizationID;

  @override
  List<Object> get props => [organizations, username, organizationID];
}

class LoginInitial extends LoginState {}

class LoginInitializationError extends LoginState {
  LoginInitializationError({@required this.messageKey});

  final String messageKey;

  @override
  List<Object> get props =>
      [organizations, username, organizationID, messageKey];
}

class LoginReady extends LoginState {
  LoginReady({
    @required OrganizationCollection organizations,
    @required String username,
    @required String organizationID,
  }) : super(
            organizations: organizations,
            username: username,
            organizationID: organizationID);
}

class LoginInProgress extends LoginState {
  LoginInProgress({
    @required OrganizationCollection organizations,
    @required String username,
    @required String organizationID,
  }) : super(
            organizations: organizations,
            username: username,
            organizationID: organizationID);
}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  LoginError({
    @required OrganizationCollection organizations,
    @required String username,
    @required String organizationID,
    @required this.messageKey,
  }) : super(
            organizations: organizations,
            username: username,
            organizationID: organizationID);

  final String messageKey;

  @override
  List<Object> get props =>
      [organizations, username, organizationID, messageKey];
}

class OpenAppConnectionPage extends LoginState {}
