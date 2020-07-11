import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_connect_bloc.dart';

class AppconnectControls extends StatefulWidget {
  AppconnectControls({Key key}) : super(key: key);

  @override
  _AppconnectControlsState createState() => _AppconnectControlsState();
}

class _AppconnectControlsState extends State<AppconnectControls> {
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
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    icon: Text('https://'),
                    hintText: 'etrax.at/appdata',
                  ),
                  onChanged: (value) {
                    inputStr = value;
                  },
                  validator: (val) =>
                      val.length < 1 ? 'Bitte dieses Feld ausfüllen' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text('Link'),
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
      BlocProvider.of<AppConnectBloc>(context)
          .add((ConnectApp(uriString: 'https://' + inputStr)));
    }
  }
}
