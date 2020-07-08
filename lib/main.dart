import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
        primaryColor: Colors.red.shade800,
        accentColor: Colors.green.shade600,
      ),
      builder: ExtendedNavigator<Router>(router: Router()),
    );
  }
}
