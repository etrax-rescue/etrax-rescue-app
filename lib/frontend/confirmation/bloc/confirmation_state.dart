part of 'confirmation_bloc.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();
  @override
  List<Object> get props => [];
}

class ConfirmationInitial extends ConfirmationState {}

class ConfirmationInProgress extends ConfirmationState {}

class ConfirmationSuccess extends ConfirmationState {}

class ConfirmationError extends ConfirmationState {
  final String messageKey;
  ConfirmationError({@required this.messageKey});

  @override
  List<Object> get props => [messageKey];
}
