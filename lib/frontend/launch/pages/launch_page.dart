import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/widgets/background.dart';
import 'package:flutter/material.dart';

import '../../../routes/router.gr.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ExtendedNavigator.of(context).popAndPush(Routes.appConnectionPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
