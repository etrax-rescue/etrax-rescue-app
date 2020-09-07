import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes/router.gr.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../widgets/background.dart';
import '../bloc/missions_bloc.dart';
import '../../widgets/custom_material_icons.dart';
import '../widgets/missions_list.dart';

class MissionPage extends StatelessWidget implements AutoRouteWrapper {
  const MissionPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            sl<InitializationBloc>()..add(StartFetchingInitializationData()),
        child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MISSIONS),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BlocProvider.of<InitializationBloc>(context).add(LogoutEvent());
        },
        label: Text(S.of(context).LOGOUT),
        icon: Icon(CustomMaterialIcons.logout),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: BlocListener<InitializationBloc, InitializationState>(
        listener: (context, state) {
          if (state is InitializationLogoutSuccess) {
            ExtendedNavigator.of(context).popAndPush(Routes.launchPage);
          }
        },
        child: Background(
          child: MissionList(),
        ),
      ),
    );
  }
}
