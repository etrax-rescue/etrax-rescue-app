part of 'app_connect_bloc.dart';

abstract class AppConnectState extends Equatable {
  const AppConnectState();
}

class AppConnectInitial extends AppConnectState {
  @override
  List<Object> get props => [];
}

class AppConnectVerifying extends AppConnectState {
  @override
  List<Object> get props => [];
}

class AppConnectStored extends AppConnectState {
  @override
  List<Object> get props => [];
}

class AppConnectError extends AppConnectState {
  final String message;

  AppConnectError({@required this.message});

  @override
  List<Object> get props => [message];
}
