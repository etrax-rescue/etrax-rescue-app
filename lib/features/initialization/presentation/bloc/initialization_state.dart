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

class InitializationFetched extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationError extends InitializationState {
  final String messageKey;

  InitializationError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
