import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({Key key, @required this.onPressed}) : super(key: key);

  final Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(context),
      color: Theme.of(context).errorColor,
      child: Text(
        S.of(context).RETRY,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}
