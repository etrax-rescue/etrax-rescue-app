import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../bloc/app_connection_bloc.dart';

class AppConnectionControls extends StatefulWidget {
  AppConnectionControls({Key key}) : super(key: key);

  @override
  _AppConnectionControlsState createState() => _AppConnectionControlsState();
}

class _AppConnectionControlsState extends State<AppConnectionControls> {
  final _formKey = GlobalKey<FormState>();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    icon: Text('https://'),
                    hintText: 'etrax.at',
                  ),
                  onChanged: (value) {
                    inputStr = value;
                  },
                  validator: (val) =>
                      val.length < 1 ? S.of(context).FIELD_REQUIRED : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text(S.of(context).CONNECT),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: submit,
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AppConnectionBloc>(context)
          .add((ConnectApp(authority: inputStr)));
    }
  }
}
