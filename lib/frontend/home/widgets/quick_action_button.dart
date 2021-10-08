// @dart=2.9
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';
import '../../check_requirements/cubit/check_requirements_cubit.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({Key key, @required this.action}) : super(key: key);

  final UserState action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: MaterialButton(
        height: 48,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48.0),
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
                      AutoRouter.of(context).popAndPush(
                        CheckRequirementsPageRoute(
                          currentState: action,
                          desiredState: action,
                          action: StatusAction.quickAction,
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
      ),
    );
  }
}
