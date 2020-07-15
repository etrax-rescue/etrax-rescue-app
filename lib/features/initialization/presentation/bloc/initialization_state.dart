part of 'initialization_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState();
}

class InitializationInitial extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationFetching extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationSuccess extends InitializationState {
  @override
  List<Object> get props => [];
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
