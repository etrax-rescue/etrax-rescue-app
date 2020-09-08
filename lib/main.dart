import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl_standalone.dart';

import 'generated/l10n.dart';
import 'injection_container.dart' as di;
import 'routes/router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await findSystemLocale();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EtraxApp());
}

class EtraxApp extends StatelessWidget {
  const EtraxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eTrax|rescue',
      theme: ThemeData(
        backgroundColor: const Color(0xFFFAFAFA), //const Color(0xFF718792),
        primaryColor: const Color(0xFF465a64), //const Color(0xFF1c313a),
        accentColor: const Color(0xffd32f2f), //const Color(0xFFD3302F),

        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xFF465a64)),
            color: Color(0xFF465a64)),
        textTheme: TextTheme(
          headline5: const TextStyle(color: Color(0xFF465a64)),
          bodyText1: const TextStyle(color: Color(0xFF465a64)),
          bodyText2: const TextStyle(color: Color(0xFF465a64)),
          subtitle1: const TextStyle(color: Color(0xFF465a64)),
        ),
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: ExtendedNavigator<Router>(router: Router()),
    );
  }
}
