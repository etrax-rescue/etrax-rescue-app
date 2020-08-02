part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class LoginReady extends AuthenticationState {
  final OrganizationCollectionModel organizationCollection;

  LoginReady({@required this.organizationCollection});

  @override
  List<Object> get props => [organizationCollection];
}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String messageKey;

  AuthenticationError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}

class RequestedAppConnectionUpdate extends AuthenticationState {}
