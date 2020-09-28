import 'package:flutter/material.dart';

import '../../../backend/types/user_states.dart';
import 'quick_action_button.dart';

class QuickActionsBox extends StatelessWidget {
  const QuickActionsBox({Key key, @required this.actions}) : super(key: key);

  final List<UserState> actions;

  @override
  Widget build(BuildContext context) {
    final quickActions = List<Widget>.from(
        actions.map((action) => QuickActionButton(action: action)));

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 32,
      child: Builder(
        builder: (context) {
          if (MediaQuery.of(context).size.height / 3 < 3 * 48) {
            return SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: quickActions,
              ),
            );
          }
          return Wrap(
            clipBehavior: Clip.none,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: quickActions,
          );
        },
      ),
    );
  }
}
