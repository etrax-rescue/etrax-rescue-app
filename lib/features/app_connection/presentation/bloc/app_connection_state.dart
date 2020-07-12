part of 'app_connection_bloc.dart';

abstract class AppConnectionState extends Equatable {
  const AppConnectionState();
}

class AppConnectionInitial extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionVerifying extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionSuccess extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionError extends AppConnectionState {
  final String message;

  AppConnectionError({@required this.message});

  @override
  List<Object> get props => [message];
}
