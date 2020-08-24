import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

enum PopupChoices {
  relink,
}

class RelinkPopupMenu extends StatelessWidget {
  final VoidCallback callback;
  const RelinkPopupMenu({Key key, @required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == PopupChoices.relink) {
          if (callback != null) {
            callback();
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoices>>[
        PopupMenuItem<PopupChoices>(
          value: PopupChoices.relink,
          child: Text(S.of(context).RECONNECT),
        ),
      ],
    );
  }
}
