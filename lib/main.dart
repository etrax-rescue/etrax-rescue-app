import 'package:flutter/material.dart';

import 'features/link/presentation/pages/link_app_page.dart';
import 'injection_container.dart' as di;

void main() async {
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
      home: LinkAppPage(),
    );
  }
}
