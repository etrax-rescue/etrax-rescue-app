part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class InitializeLogin extends LoginEvent {}

class SubmitLogin extends LoginEvent {
  final String username;
  final String password;

  SubmitLogin({@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];
}

class RequestAppConnectionUpdate extends LoginEvent {}
