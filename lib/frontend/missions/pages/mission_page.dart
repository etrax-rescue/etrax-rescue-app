import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../widgets/background.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/missions_list.dart';
import '../widgets/custom_material_icons_icons.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<InitializationBloc>()..add(StartFetchingInitializationData()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).MISSIONS),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: change to logout bloc action
            ExtendedNavigator.of(context).popAndPush('/login-page');
          },
          label: Text(S.of(context).LOGOUT),
          icon: Icon(CustomMaterialIcons.logout_24px),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Background(
          child: Container(
            alignment: Alignment.center,
            child: MissionList(),
          ),
        ),
      ),
    );
  }
}
