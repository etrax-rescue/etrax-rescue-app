import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../bloc/app_connection_bloc.dart';

class AppConnectionPage extends StatelessWidget {
  const AppConnectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppConnectionBloc>(),
      child: BlocBuilder<AppConnectionBloc, AppConnectionState>(
        builder: (context, state) {
          if (state is AppConnectionInitial) {
            // Ask if we should update the app connection
            BlocProvider.of<AppConnectionBloc>(context)
                .add(CheckUpdateStatus());
            return Container();
          } else if (state is AppConnectionSuccess) {
            // Go to next page when no update is required or when the update succeeded
            ExtendedNavigator.root.pushReplacementNamed('/login-page');
            return Container();
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: CenteredCardView(
                  child: AppConnectionForm(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CenteredCardView extends StatelessWidget {
  final Widget child;
  const CenteredCardView({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          alignment: Alignment.center,
          child: Card(
            child: Container(
              constraints: BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppConnectionForm extends StatefulWidget {
  AppConnectionForm({Key key}) : super(key: key);

  @override
  _AppConnectionFormState createState() => _AppConnectionFormState();
}

class _AppConnectionFormState extends State<AppConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).APP_CONNECT_HEADING,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextFormField(
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
          SizedBox(height: 10),
          BlocBuilder<AppConnectionBloc, AppConnectionState>(
              builder: (context, state) {
            if (state is AppConnectionError) {
              return Text(
                translateErrorMessage(context, state.messageKey),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              );
            } else if (state is AppConnectionVerifying) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
          BlocBuilder<AppConnectionBloc, AppConnectionState>(
            builder: (context, state) {
              if (!(state is AppConnectionVerifying)) {
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
          .add((ConnectApp(authority: inputStr)));
    }
  }
}
