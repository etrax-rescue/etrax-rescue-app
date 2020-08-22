import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../backend/types/initialization_data.dart';
import '../../../backend/types/missions.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../bloc/initialization_bloc.dart';

class MissionList extends StatefulWidget {
  MissionList({Key key}) : super(key: key);

  @override
  _MissionListState createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  Completer<void> _refreshCompleter;
  InitializationData initializationData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    final missionCollection = MissionCollection(missions: []);
    final userStateCollection = UserStateCollection(states: []);
    final userRoleCollection = UserRoleCollection(roles: []);
    initializationData = InitializationData(
        appConfiguration: null,
        missionCollection: missionCollection,
        userStateCollection: userStateCollection,
        userRoleCollection: userRoleCollection);

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      this._refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        BlocProvider.of<InitializationBloc>(context)
            .add(StartFetchingInitializationData());
        Scaffold.of(context).hideCurrentSnackBar();
        return _refreshCompleter.future;
      },
      child: BlocListener<InitializationBloc, InitializationState>(
        listener: (context, state) {
          if (state is InitializationInitial ||
              state is InitializationInProgress) {
            return;
          }
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
          if (state is InitializationRecoverableError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(translateErrorMessage(context, state.messageKey)),
                duration: const Duration(days: 365),
                action: SnackBarAction(
                  label: S.of(context).RETRY,
                  onPressed: () {
                    BlocProvider.of<InitializationBloc>(context)
                        .add(StartFetchingInitializationData());
                    Scaffold.of(context).hideCurrentSnackBar();
                    _refreshIndicatorKey.currentState.show();
                  },
                ),
              ),
            );
          } else if (state is InitializationUnrecoverableError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(translateErrorMessage(context, state.messageKey)),
                duration: const Duration(days: 365),
              ),
            );
          } else if (state is InitializationSuccess) {
            setState(() {
              initializationData = state.initializationData;
            });
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: initializationData.missionCollection.missions.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: InkWell(
                onTap: () {
                  ExtendedNavigator.of(context).push(
                    '/confirmation-page',
                    arguments: ConfirmationPageArguments(
                      mission:
                          initializationData.missionCollection.missions[index],
                      states: initializationData.userStateCollection,
                      roles: initializationData.userRoleCollection,
                    ),
                  );
                },
                child: ListTile(
                  title: Text(initializationData
                      .missionCollection.missions[index].name),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy - HH:mm').format(initializationData
                        .missionCollection.missions[index].start),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
