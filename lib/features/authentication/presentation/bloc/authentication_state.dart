part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationVerifying extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationState {
  final String messageKey;

  AuthenticationError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}

class RequestedAppConnectionUpdate extends AuthenticationState {
  @override
  List<Object> get props => [];
}
