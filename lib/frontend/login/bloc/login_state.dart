part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginReady extends LoginState {
  final OrganizationCollection organizationCollection;

  LoginReady({@required this.organizationCollection});

  @override
  List<Object> get props => [organizationCollection];
}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String messageKey;

  LoginError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}

class RequestedAppConnectionUpdate extends LoginState {}
