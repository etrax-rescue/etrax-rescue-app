import 'package:flutter/material.dart';

import '../../../backend/domain/entities/missions.dart';
import '../../../backend/domain/entities/user_roles.dart';
import '../../../backend/domain/entities/user_states.dart';
import '../../../generated/l10n.dart';
import '../widgets/confirmation_form.dart';

class ConfirmationPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).CONFIRMATION_HEADING)),
      body: SingleChildScrollView(
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
    );
  }
}
