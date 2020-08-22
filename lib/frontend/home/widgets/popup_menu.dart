import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

enum PopupChoices {
  settings,
}

class HomePopupMenu extends StatelessWidget {
  final VoidCallback callback;
  const HomePopupMenu({Key key, @required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == PopupChoices.settings) {
          if (callback != null) {
            callback();
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoices>>[
        PopupMenuItem<PopupChoices>(
          value: PopupChoices.settings,
          child: Text(S.of(context).SETTINGS),
        ),
      ],
    );
  }
}
