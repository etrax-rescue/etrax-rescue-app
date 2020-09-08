import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../generated/l10n.dart';

enum PopupChoices {
  about,
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case PopupChoices.about:
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            showAboutDialog(
              context: context,
              applicationName: S.of(context).APP_NAME,
              applicationIcon:
                  Image.asset('assets/images/etrax_rescue_icon.png'),
              applicationVersion: packageInfo.version,
              applicationLegalese: 'Hi there!',
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoices>>[
        PopupMenuItem<PopupChoices>(
          value: PopupChoices.about,
          child: Text(S.of(context).ABOUT),
        ),
      ],
    );
  }
}
