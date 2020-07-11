import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'injection_container.dart' as di;
import 'routes/router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(EtraxApp());
}

class EtraxApp extends StatelessWidget {
  const EtraxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eTrax|rescue',
      theme: ThemeData(
        primaryColor: const Color(0xFF1c313a),
        accentColor: const Color(0xFFD3302F),
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
