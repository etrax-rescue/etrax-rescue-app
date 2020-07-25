part of 'app_connection_bloc.dart';

abstract class AppConnectionState extends Equatable {
  const AppConnectionState();
  @override
  List<Object> get props => [];
}

class AppConnectionInitial extends AppConnectionState {}

class AppConnectionStateReady extends AppConnectionState {}

class AppConnectionStateInProgress extends AppConnectionState {}

class AppConnectionStateSuccess extends AppConnectionState {}

class AppConnectionStateError extends AppConnectionState {
  final String messageKey;
  AppConnectionStateError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
