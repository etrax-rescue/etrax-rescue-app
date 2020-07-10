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
              hintText: 'username',
            ),
            onChanged: (value) {
              _usernameStr = value;
            },
            onSaved: (value) {
              _usernameStr = value;
            },
            validator: (val) =>
                val.length < 1 ? 'Bitte dieses Feld ausfüllen' : null,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'password',
            ),
            onChanged: (value) {
              _passwordStr = value;
            },
            onSaved: (value) {
              _passwordStr = value;
            },
            validator: (val) =>
                val.length < 1 ? 'Bitte dieses Feld ausfüllen' : null,
            obscureText: true,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text('Login'),
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
