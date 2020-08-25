part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class SubmitLogin extends LoginEvent {
  final String username;
  final String password;
  final String organizationID;

  SubmitLogin(
      {@required this.username,
      @required this.password,
      @required this.organizationID});

  @override
  List<Object> get props => [username, password, organizationID];
}

class RequestAppConnectionUpdate extends LoginEvent {}
