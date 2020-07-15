import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../bloc/initialization_bloc.dart';

class RecoverableErrorDisplay extends StatefulWidget {
  final String message;
  RecoverableErrorDisplay({Key key, this.message}) : super(key: key);

  @override
  _RecoverableErrorDisplayState createState() =>
      _RecoverableErrorDisplayState(message);
}

class _RecoverableErrorDisplayState extends State<RecoverableErrorDisplay> {
  final String message;
  _RecoverableErrorDisplayState(this.message);

  void _retry() {
    BlocProvider.of<InitializationBloc>(context)
        .add(StartFetchingInitializationData());
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
          child: Text(S.of(context).RETRY),
          textTheme: ButtonTextTheme.primary,
          onPressed: _retry,
        ),
      ],
    );
  }
}
