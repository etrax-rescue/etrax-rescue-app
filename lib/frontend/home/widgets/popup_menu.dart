import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

enum PopupChoices {
  settings,
  about,
}

class HomePopupMenu extends StatelessWidget {
  const HomePopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case PopupChoices.settings:
            print('opening settings...');
            break;
          case PopupChoices.about:
            showAboutDialog(
              context: context,
              applicationName: S.of(context).APP_NAME,
              applicationIcon:
                  Image.asset('assets/images/etrax_rescue_icon.png'),
              applicationVersion: '0.2',
              applicationLegalese: 'Hi there!',
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoices>>[
        PopupMenuItem<PopupChoices>(
          value: PopupChoices.settings,
          child: Text(S.of(context).SETTINGS),
        ),
        PopupMenuItem<PopupChoices>(
          value: PopupChoices.about,
          child: Text(S.of(context).ABOUT),
        ),
      ],
    );
  }
}
