import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/organizations.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../widgets/background.dart';
import '../../widgets/centered_card_view.dart';
import '../bloc/login_bloc.dart';
import '../widgets/login_form.dart';
import '../widgets/relink_popup_menu.dart';

class LoginPage extends StatefulWidget {
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
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      // this builder is used so that the LoginBloc is available with the context of all child widgets
      child: Builder(
        builder: (context) {
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
                    ExtendedNavigator.of(context)
                        .popAndPush(Routes.missionPage);
                  } else if (state is RequestedAppConnectionUpdate) {
                    ExtendedNavigator.of(context)
                        .popAndPush(Routes.appConnectionPage);
                  }
                },
                builder: (context, state) {
                  if (widget.organizations != null) {
                    return Center(
                      child: SingleChildScrollView(
                        child: CenteredCardView(
                          child: LoginForm(
                            organizationCollection: widget.organizations,
                            username: widget.username,
                            organizationID: widget.organizationID,
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
        },
      ),
    );
  }
}
