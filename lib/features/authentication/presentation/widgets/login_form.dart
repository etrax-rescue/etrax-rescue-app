import 'package:etrax_rescue_app/features/authentication/domain/entities/organizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final OrganizationCollection organizationCollection;
  LoginForm({Key key, @required this.organizationCollection}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState(this.organizationCollection);
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _usernameStr;
  String _passwordStr;
  OrganizationCollection organizationCollection;
  String _organizationID;
  _LoginFormState(this.organizationCollection);

  @override
  void initState() {
    super.initState();
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
              items: organizationCollection.organizations
                  .map((Organization organization) {
                return DropdownMenuItem<String>(
                  value: organization.id,
                  child: Text(organization.name),
                );
              }).toList(),
              onChanged: (val) {
                _organizationID = val;
              },
              validator: (val) =>
                  val == null ? S.of(context).FIELD_REQUIRED : null,
            ),
            visible: organizationCollection.organizations.length > 1,
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
          BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (state is LoginError) {
              return Text(
                translateErrorMessage(context, state.messageKey),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              );
            } else if (state is LoginInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (!(state is LoginInProgress)) {
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
      BlocProvider.of<LoginBloc>(context).add(SubmitLogin(
          username: _usernameStr,
          password: _passwordStr,
          organizationID: _organizationID));
    }
  }
}
