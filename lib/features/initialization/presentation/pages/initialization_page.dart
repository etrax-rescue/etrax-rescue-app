import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/missions.dart';
import '../bloc/initialization_bloc.dart';
import 'custom_material_icons_icons.dart';

enum PopupChoices {
  relink,
}

final List<Widget> _popupActions = <Widget>[
  PopupMenuButton(
    onSelected: (value) {
      if (value == PopupChoices.relink) {
        ExtendedNavigator.root.pushReplacementNamed('/');
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoices>>[
      PopupMenuItem<PopupChoices>(
        value: PopupChoices.relink,
        child: Text(S.of(context).RECONNECT),
      ),
    ],
  ),
];

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
          actions: _popupActions,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: _createLogoutFab(context),
        body: Container(
          alignment: Alignment.center,
          child: BlocConsumer<InitializationBloc, InitializationState>(
            listener: (context, state) {
              if (state is InitializationRecoverableError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(translateErrorMessage(context, state.messageKey)),
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
                    content:
                        Text(translateErrorMessage(context, state.messageKey)),
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
                    } else if (state is InitializationFetching) {
                      return _createInitialView();
                    }
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                    if (state is InitializationSuccess) {
                      _missionCollection = state.missionCollection;
                      return MissionList(missionCollection: _missionCollection);
                    } else if (state is InitializationRecoverableError) {
                      return _createInitialView();
                    } else if (state is InitializationUnrecoverableError) {
                      return _createInitialView();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _createLogoutFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        ExtendedNavigator.root.pushReplacementNamed('/login-page');
      },
      label: Text(S.of(context).LOGOUT),
      icon: Icon(CustomMaterialIcons.logout_24px),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _createInitialView() {
    return MissionList(missionCollection: MissionCollection(missions: []));
  }
}

class MissionList extends StatelessWidget {
  final MissionCollection missionCollection;
  const MissionList({Key key, this.missionCollection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: missionCollection.missions.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(missionCollection.missions[index].name),
              subtitle: Text(DateFormat('dd.MM.yyyy - HH:mm')
                  .format(missionCollection.missions[index].start)),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}
