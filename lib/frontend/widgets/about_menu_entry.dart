import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../generated/l10n.dart';
import 'popup_menu.dart';

PopupAction generateAboutMenuEntry(BuildContext context) {
  return PopupAction(
    child: Text(S.of(context).ABOUT),
    onPressed: () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      showAboutDialog(
        context: context,
        applicationName: S.of(context).APP_NAME,
        applicationIcon: Image.asset('assets/images/etrax_rescue_icon.png'),
        applicationVersion: packageInfo.version,
        applicationLegalese: S.of(context).LEGALESE,
      );
    },
  );
}
