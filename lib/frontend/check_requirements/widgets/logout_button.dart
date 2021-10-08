// @dart=2.9
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/custom_material_icons.dart';
import '../cubit/check_requirements_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CustomMaterialIcons.logout),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).LOGOUT),
              content: Text(S.of(context).CONFIRM_LOGOUT),
              actions: [
                TextButton(
                  child: Text(S.of(context).CANCEL),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(S.of(context).YES),
                  onPressed: () {
                    AutoRouter.of(context).pushAndPopUntil(
                      CheckRequirementsPageRoute(
                          desiredState: null,
                          currentState: null,
                          action: StatusAction.logout),
                      predicate: (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
