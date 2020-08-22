part of 'confirmation_bloc.dart';

abstract class ConfirmationEvent extends Equatable {
  const ConfirmationEvent();
  @override
  List<Object> get props => [];
}

class SubmitConfirmation extends ConfirmationEvent {
  final int userRoleID;
  final int userStateID;
  SubmitConfirmation({@required this.userRoleID, @required this.userStateID});

  @override
  List<Object> get props => [userRoleID, userStateID];
}
