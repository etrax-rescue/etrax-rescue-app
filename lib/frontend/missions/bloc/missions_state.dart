part of 'missions_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState({@required this.initializationData});

  final InitializationData initializationData;

  @override
  List<Object> get props => [initializationData];
}

class InitializationInitial extends InitializationState {}

class InitializationInProgress extends InitializationState {
  InitializationInProgress({@required InitializationData initializationData})
      : super(initializationData: initializationData);
}

class InitializationSuccess extends InitializationState {
  InitializationSuccess({@required InitializationData initializationData})
      : super(initializationData: initializationData);
}

class InitializationLogoutSuccess extends InitializationState {}

class InitializationRecoverableError extends InitializationState {
  final String messageKey;

  InitializationRecoverableError(
      {@required InitializationData initializationData,
      @required this.messageKey})
      : super(initializationData: initializationData);

  @override
  List<Object> get props => [initializationData, messageKey];
}

class InitializationUnrecoverableError extends InitializationState {
  final String messageKey;

  InitializationUnrecoverableError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
