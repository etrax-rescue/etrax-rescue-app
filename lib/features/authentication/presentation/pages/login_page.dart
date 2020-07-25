import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/background.dart';
import '../../../../common/widgets/centered_card_view.dart';
import '../../../../common/widgets/popup_menu.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<AuthenticationBloc>(), child: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).LOGIN_HEADING),
        actions: <Widget>[
          RelinkPopupMenu(callback: () {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(RequestAppConnectionUpdate());
          }),
        ],
      ),
      body: Background(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              ExtendedNavigator.of(context).popAndPush('/mission-page');
            } else if (state is RequestedAppConnectionUpdate) {
              ExtendedNavigator.of(context).popAndPush('/');
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: CenteredCardView(
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
