import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../app_connection/presentation/widgets/loading_widget.dart';
import '../../../app_connection/presentation/widgets/message_display.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/login_controls.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: buildBody(context),
        ),
      ),
    );
  }
}

BlocProvider<AuthenticationBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<AuthenticationBloc>(),
    child: Container(
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
                          if (state is AuthenticationVerifying) {
                            return LoadingWidget();
                          } else if (state is AuthenticationSuccess) {
                            return MessageDisplay(
                                message: S.of(context).AUTHENTICATION_SUCCESS);
                          } else if (state is AuthenticationError) {
                            return MessageDisplay(
                              message: translateErrorMessage(
                                  context, state.message_key),
                            );
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
    ),
  );
}
