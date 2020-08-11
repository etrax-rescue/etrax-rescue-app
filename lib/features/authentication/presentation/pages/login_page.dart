import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/background.dart';
import '../../../../common/widgets/centered_card_view.dart';
import '../widgets/relink_popup_menu.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/organizations.dart';
import '../bloc/login_bloc.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>()..add(InitializeLogin()),
      child: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  OrganizationCollection _organizations;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).LOGIN_HEADING),
        actions: <Widget>[
          RelinkPopupMenu(callback: () {
            BlocProvider.of<LoginBloc>(context)
                .add(RequestAppConnectionUpdate());
          }),
        ],
      ),
      body: Background(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ExtendedNavigator.of(context).popAndPush('/mission-page');
            } else if (state is RequestedAppConnectionUpdate) {
              ExtendedNavigator.of(context).popAndPush('/');
            } else if (state is LoginReady) {
              _organizations = state.organizationCollection;
            }
          },
          builder: (context, state) {
            if (_organizations != null) {
              return Center(
                child: SingleChildScrollView(
                  child: CenteredCardView(
                    child: LoginForm(
                      organizationCollection: _organizations,
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
