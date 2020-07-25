part of 'confirmation_bloc.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();
}

class ConfirmationInitial extends ConfirmationState {
  @override
  List<Object> get props => [];
}
