import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/organizations.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/background.dart';
import '../../widgets/centered_card_view.dart';
import '../bloc/login_bloc.dart';
import '../widgets/login_form.dart';
import '../widgets/relink_popup_menu.dart';

class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  final OrganizationCollection organizations;
  final String username;
  final String organizationID;

  const LoginPage({
    Key key,
    @required this.organizations,
    @required this.username,
    @required this.organizationID,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => sl<LoginBloc>(), child: this);
  }

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
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ExtendedNavigator.of(context).popAndPush(Routes.missionPage);
            } else if (state is RequestedAppConnectionUpdate) {
              ExtendedNavigator.of(context)
                  .popAndPush(Routes.appConnectionPage);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: CenteredCardView(
                child: LoginForm(
                  organizationCollection: organizations,
                  username: username,
                  organizationID: organizationID,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
