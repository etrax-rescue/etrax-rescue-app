import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/missions.dart';
import '../widgets/confirmation_form.dart';

class ConfirmationPage extends StatelessWidget {
  final Mission mission;
  ConfirmationPage({Key key, @required this.mission}) : super(key: key);

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
            ),
          ),
        ),
      ),
    );
  }
}
