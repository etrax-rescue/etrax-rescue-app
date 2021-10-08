// @dart=2.9
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
          applicationIcon: Image.asset('assets/images/small_icon.png'),
          applicationVersion: packageInfo.version,
          children: [
            Text(S.of(context).LEGALESE),
            InkWell(
              child: Text(
                S.of(context).PRIVACY_NOTICE,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async => await launch('https://etrax.at/datenschutz/'),
            ),
          ]);
    },
  );
}
