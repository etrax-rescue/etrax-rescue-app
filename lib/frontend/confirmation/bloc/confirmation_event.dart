// @dart=2.9
part of 'confirmation_bloc.dart';

abstract class ConfirmationEvent extends Equatable {
  const ConfirmationEvent();
  @override
  List<Object> get props => [];
}

class SubmitConfirmation extends ConfirmationEvent {
  final Mission mission;
  final UserRole role;
  SubmitConfirmation({@required this.mission, @required this.role});

  @override
  List<Object> get props => [mission, role];
}

class LogoutEvent extends ConfirmationEvent {}
