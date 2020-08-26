import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/background.dart';
import '../bloc/launch_bloc.dart';

class LaunchPage extends StatelessWidget implements AutoRouteWrapper {
  const LaunchPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<LaunchBloc>()..add(Launch()), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: BlocConsumer<LaunchBloc, LaunchState>(
          listener: (context, state) {
            print(state);
            if (state is LaunchAppConnectionPage) {
              ExtendedNavigator.of(context)
                  .popAndPush(Routes.appConnectionPage);
            } else if (state is LaunchLoginPage) {
              ExtendedNavigator.of(context).popAndPush(Routes.loginPage,
                  arguments: LoginPageArguments(
                      organizations: state.organizations,
                      username: state.username,
                      organizationID: state.organizationID));
            } else if (state is LaunchHomePage) {
              ExtendedNavigator.of(context).popAndPush(Routes.homePage,
                  arguments:
                      HomePageArguments(state: state.missionState.state));
            }
          },
          builder: (context, state) {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
