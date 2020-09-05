import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../util/translate_error_messages.dart';
import '../bloc/app_connection_bloc.dart';

class AppConnectionForm extends StatefulWidget {
  AppConnectionForm({Key key}) : super(key: key);

  @override
  _AppConnectionFormState createState() => _AppConnectionFormState();
}

class _AppConnectionFormState extends State<AppConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  String _inputStr;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).APP_CONNECTION_HEADING,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
                icon: Text('https://'),
                hintText: 'etrax.at',
                suffixIcon: Icon(Icons.camera_alt)),
            onChanged: (value) {
              _inputStr = value;
            },
            validator: (val) =>
                val.length < 1 ? S.of(context).FIELD_REQUIRED : null,
          ),
          SizedBox(height: 10),
          BlocBuilder<AppConnectionBloc, AppConnectionState>(
              builder: (context, state) {
            if (state is AppConnectionStateError) {
              return Text(
                translateErrorMessage(context, state.messageKey),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              );
            } else if (state is AppConnectionStateInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
          BlocBuilder<AppConnectionBloc, AppConnectionState>(
            builder: (context, state) {
              if (!(state is AppConnectionStateInProgress)) {
                return ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: submit,
                    child: Text(S.of(context).CONNECT),
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
      BlocProvider.of<AppConnectionBloc>(context)
          .add((SubmitAppConnection(authority: _inputStr)));
    }
  }
}
