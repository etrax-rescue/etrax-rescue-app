import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../appconnect/presentation/widgets/loading_widget.dart';
import '../../../appconnect/presentation/widgets/message_display.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/login_controls.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
}

BlocProvider<AuthenticationBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<AuthenticationBloc>(),
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Anmelden:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is AuthenticationInitial) {
                        return Container();
                      } else if (state is AuthenticationVerifying) {
                        return LoadingWidget();
                      } else if (state is AuthenticationSuccess) {
                        return MessageDisplay(message: 'Erfolg!');
                      } else if (state is AuthenticationError) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
                    },
                  ),
                  LoginControls(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
