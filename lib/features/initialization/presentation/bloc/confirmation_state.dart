part of 'confirmation_bloc.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();
  @override
  List<Object> get props => [];
}

class ConfirmationInitial extends ConfirmationState {}
