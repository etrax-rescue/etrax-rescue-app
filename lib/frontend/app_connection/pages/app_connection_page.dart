import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/app_connection/cubit/app_connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/background.dart';
import '../../widgets/centered_card_view.dart';
import '../widgets/app_connection_form.dart';

class AppConnectionPage extends StatelessWidget implements AutoRouteWrapper {
  const AppConnectionPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => sl<AppConnectionCubit>(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Background(
        child: BlocListener<AppConnectionCubit, AppConnectionState>(
          listener: (context, state) {
            if (state.status == AppConnectionStatus.success) {
              // Go to next page when no update is required or when the update succeeded
              ExtendedNavigator.root.popAndPush(Routes.launchPage);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: CenteredCardView(
                child: AppConnectionForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
