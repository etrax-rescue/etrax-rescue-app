import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/missions.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../bloc/confirmation_bloc.dart';
import '../widgets/confirmation_form.dart';

class ConfirmationPage extends StatelessWidget implements AutoRouteWrapper {
  final Mission mission;
  final UserRoleCollection roles;
  final UserStateCollection states;
  ConfirmationPage(
      {Key key,
      @required this.mission,
      @required this.roles,
      @required this.states})
      : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => sl<ConfirmationBloc>(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).CONFIRMATION_HEADING)),
      body: BlocListener<ConfirmationBloc, ConfirmationState>(
        listener: (context, state) {
          if (state is ConfirmationSuccess) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(
                Routes.checkRequirementsPage,
                arguments:
                    CheckRequirementsPageArguments(state: states.states[0]));
          } else if (state is ConfirmationError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(translateErrorMessage(context, state.messageKey)),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(maxWidth: 450),
              child: ConfirmationForm(
                mission: this.mission,
                roles: roles,
                states: states,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
