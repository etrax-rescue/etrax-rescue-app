import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UnrecoverableErrorDisplay extends StatelessWidget {
  final String message;
  const UnrecoverableErrorDisplay({
    Key key,
    @required this.message,
  }) : super(key: key);

  void _goBack() {
    ExtendedNavigator.root.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          message,
          style: TextStyle(fontSize: 12, color: Theme.of(context).accentColor),
        ),
        RaisedButton(
          child: Text(S.of(context).BACK),
          textTheme: ButtonTextTheme.primary,
          onPressed: _goBack,
        ),
      ],
    );
  }
}
