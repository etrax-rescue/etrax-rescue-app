import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter/material.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  ConfirmationBloc() : super(ConfirmationInitial());

  @override
  Stream<ConfirmationState> mapEventToState(
    ConfirmationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
