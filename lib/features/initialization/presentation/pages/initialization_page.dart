import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/initialization_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/background.dart';
import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/missions.dart';
import '../bloc/initialization_bloc.dart';
import '../widgets/mission_list.dart';
import 'custom_material_icons_icons.dart';

class MissionPage extends StatefulWidget {
  MissionPage({Key key}) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  MissionCollection _missionCollection;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _missionCollection = MissionCollection(missions: []);
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InitializationBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).MISSIONS),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: _createLogoutFab(context),
        body: Background(
          child: Container(
            alignment: Alignment.center,
            child: BlocConsumer<InitializationBloc, InitializationState>(
              listener: (context, state) {
                if (state is InitializationRecoverableError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          translateErrorMessage(context, state.messageKey)),
                      duration: const Duration(days: 365),
                      action: SnackBarAction(
                        label: S.of(context).RETRY,
                        onPressed: () {
                          BlocProvider.of<InitializationBloc>(context)
                              .add(StartFetchingInitializationData());
                          Scaffold.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                } else if (state is InitializationUnrecoverableError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          translateErrorMessage(context, state.messageKey)),
                      duration: const Duration(days: 365),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<InitializationBloc>(context)
                        .add(StartFetchingInitializationData());
                    Scaffold.of(context).hideCurrentSnackBar();
                    return _refreshCompleter.future;
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      print(state.toString());
                      if (state is InitializationInitial) {
                        BlocProvider.of<InitializationBloc>(context)
                            .add(StartFetchingInitializationData());
                        return _createInitialView();
                      } else if (state is InitializationInProgress) {
                        return _createInitialView();
                      }
                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();
                      if (state is InitializationSuccess) {
                        return MissionList(
                            initializationData: state.initializationData);
                      } else if (state is InitializationRecoverableError) {
                        return _createInitialView();
                      } else if (state is InitializationUnrecoverableError) {
                        return _createInitialView();
                      }
                      return Container();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _createLogoutFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        ExtendedNavigator.of(context).popAndPush('/login-page');
      },
      label: Text(S.of(context).LOGOUT),
      icon: Icon(CustomMaterialIcons.logout_24px),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _createInitialView() {
    return MissionList(
        initializationData: InitializationData(
            missionCollection: MissionCollection(missions: []),
            userRoleCollection: null,
            userStateCollection: null,
            appSettings: null));
  }

  void goToAppConnection() {
    ExtendedNavigator.of(context).popAndPush('/');
  }
}
