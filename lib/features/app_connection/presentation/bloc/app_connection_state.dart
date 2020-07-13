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
  final String messageKey;
  AppConnectionError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
