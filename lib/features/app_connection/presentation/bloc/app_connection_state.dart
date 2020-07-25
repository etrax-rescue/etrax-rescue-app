part of 'app_connection_bloc.dart';

abstract class AppConnectionState extends Equatable {
  const AppConnectionState();
}

class AppConnectionInitial extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionStateReady extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionStateVerifying extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionStateSuccess extends AppConnectionState {
  @override
  List<Object> get props => [];
}

class AppConnectionStateError extends AppConnectionState {
  final String messageKey;
  AppConnectionStateError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
