part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class InitializeLogin extends AuthenticationEvent {}

class SubmitLogin extends AuthenticationEvent {
  final String username;
  final String password;

  SubmitLogin({@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];
}

class RequestAppConnectionUpdate extends AuthenticationEvent {}
