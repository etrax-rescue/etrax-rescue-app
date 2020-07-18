import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/app_connection/presentation/pages/app_connection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/login_controls.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthenticationBloc>(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            ExtendedNavigator.root.pushReplacementNamed('/mission-page');
            return Container();
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: CenteredCardView(
                  child: LoginForm(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/*
Widget buildBody(BuildContext context) {
  return Container(
    constraints: BoxConstraints(maxWidth: 450),
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Center(
          child: Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        S.of(context).LOGIN_HEADING,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        if (state is AuthenticationSuccess) {
                          ExtendedNavigator.root
                              .pushReplacementNamed('/mission-page');
                          return Container();
                        }
                        return Container();
                      },
                    ),
                    LoginControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
*/

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
          Text(
            S.of(context).LOGIN_HEADING,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
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
