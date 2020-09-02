import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/organizations.dart';
import '../../util/translate_error_messages.dart';
import '../../../generated/l10n.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final OrganizationCollection organizationCollection;
  final String username;
  final String organizationID;
  LoginForm({
    Key key,
    @required this.organizationCollection,
    @required this.username,
    @required this.organizationID,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _usernameStr = '';
  String _passwordStr = '';
  String _organizationID;
  List<DropdownMenuItem<String>> _dropdownItems;

  @override
  void initState() {
    super.initState();
    _usernameStr = widget.username != null ? widget.username : '';

    _dropdownItems = widget.organizationCollection.organizations
        .map((Organization organization) {
      return DropdownMenuItem<String>(
        value: organization.id,
        child: Text(organization.name),
      );
    }).toList();

    _organizationID = widget.organizationID != null
        ? widget.organizationID
        : _dropdownItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: S.of(context).ORGANIZATION,
                ),
                items: _dropdownItems,
                value: _organizationID,
                onChanged: (val) {
                  _organizationID = val;
                },
                validator: (val) =>
                    val == null ? S.of(context).FIELD_REQUIRED : null,
              ),
              visible: widget.organizationCollection.organizations.length > 1,
            ),
            TextFormField(
              autofocus: true,
              autofillHints: <String>[AutofillHints.username],
              initialValue: _usernameStr,
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
              autofillHints: <String>[AutofillHints.password],
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
