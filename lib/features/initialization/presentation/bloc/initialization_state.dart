part of 'initialization_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState();
  @override
  List<Object> get props => [];
}

class InitializationInitial extends InitializationState {}

class InitializationInProgress extends InitializationState {}

class InitializationSuccess extends InitializationState {
  final InitializationData initializationData;
  InitializationSuccess(this.initializationData);

  @override
  List<Object> get props => [initializationData];
}

class InitializationRecoverableError extends InitializationState {
  final String messageKey;

  InitializationRecoverableError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}

class InitializationUnrecoverableError extends InitializationState {
  final String messageKey;

  InitializationUnrecoverableError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
