import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../bloc/authentication_bloc.dart';
import '../../../../common/widgets/popup_menu.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _usernameStr;
  String _passwordStr;
  String _organizationStr;
  List<String> _organizations;

  @override
  void initState() {
    super.initState();
    _organizations = ['A', 'B'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: S.of(context).ORGANIZATION,
              ),
              items: _organizations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                _organizationStr = val;
              },
              validator: (val) =>
                  val == null ? S.of(context).FIELD_REQUIRED : null,
            ),
            visible: _organizations.length > 1,
          ),
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: S.of(context).USERNAME,
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
              labelText: S.of(context).PASSWORD,
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
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is AuthenticationError) {
              return Text(
                translateErrorMessage(context, state.messageKey),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              );
            } else if (state is AuthenticationVerifying) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (!(state is AuthenticationVerifying)) {
                return ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: submit,
                    child: Text(S.of(context).LOGIN),
                  ),
                );
              }
              return Container();
            },
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
