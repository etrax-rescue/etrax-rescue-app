import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/check_requirements/cubit/check_requirements_cubit.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:etrax_rescue_app/routes/router.gr.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/user_states.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({Key key, @required this.action}) : super(key: key);

  final UserState action;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 48,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Theme.of(context).accentColor)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).CONFIRM_CALL_TO_ACTION),
              content: Text(action.name),
              actions: [
                FlatButton(
                  child: Text(S.of(context).CANCEL),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(S.of(context).YES),
                  onPressed: () {
                    ExtendedNavigator.of(context).popAndPush(
                      Routes.checkRequirementsPage,
                      arguments: CheckRequirementsPageArguments(
                        currentState: null,
                        desiredState: action,
                        action: StatusAction.callToAction,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      textTheme: ButtonTextTheme.accent,
      child: Text(action.name),
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
