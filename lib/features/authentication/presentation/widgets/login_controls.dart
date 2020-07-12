import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';

class LoginControls extends StatefulWidget {
  LoginControls({Key key}) : super(key: key);

  @override
  _LoginControlsState createState() => _LoginControlsState();
}

class _LoginControlsState extends State<LoginControls> {
  final _formKey = GlobalKey<FormState>();
  String _usernameStr;
  String _passwordStr;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: S.of(context).USERNAME,
            ),
            onChanged: (value) {
              _usernameStr = value;
            },
            onSaved: (value) {
              _usernameStr = value;
            },
            validator: (val) =>
                val.length < 1 ? S.of(context).FIELD_REQUIRED : null,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: S.of(context).PASSWORD,
            ),
            onChanged: (value) {
              _passwordStr = value;
            },
            onSaved: (value) {
              _passwordStr = value;
            },
            validator: (val) =>
                val.length < 1 ? S.of(context).FIELD_REQUIRED : null,
            obscureText: true,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text(S.of(context).LOGIN),
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
      BlocProvider.of<AuthenticationBloc>(context)
          .add(SubmitLogin(username: _usernameStr, password: _passwordStr));
    }
  }
}
