import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/custom_material_icons.dart';
import '../../widgets/popup_menu.dart';
import '../bloc/missions_bloc.dart';

class MissionPage extends StatefulWidget implements AutoRouteWrapper {
  MissionPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
        data: ThemeData(
            appBarTheme: AppBarTheme(color: Theme.of(context).backgroundColor)),
        child: BlocProvider(
            create: (_) => sl<InitializationBloc>()
              ..add(StartFetchingInitializationData()),
            child: this));
  }

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  Completer<void> _refreshCompleter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      this._refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BlocProvider.of<InitializationBloc>(context).add(LogoutEvent());
        },
        label: Text(S.of(context).LOGOUT),
        icon: Icon(CustomMaterialIcons.logout),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Builder(
        builder: (context) {
          return BlocListener<InitializationBloc, InitializationState>(
            listener: (context, state) {
              if (state is InitializationInitial ||
                  state is InitializationInProgress) {
                return;
              }
              if (state is InitializationLogoutSuccess) {
                ExtendedNavigator.of(context).popAndPush(Routes.launchPage);
              }

              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
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
                        _refreshIndicatorKey.currentState.show();
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
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                BlocProvider.of<InitializationBloc>(context)
                    .add(StartFetchingInitializationData());
                Scaffold.of(context).hideCurrentSnackBar();
                return _refreshCompleter.future;
              },
              child: CustomScrollView(
                physics: RangeMaintainingScrollPhysics()
                    .applyTo(AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    actions: <Widget>[
                      PopupMenu(),
                    ],
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    flexibleSpace: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Image(
                          // Maybe we want to replace this with the organization logo?
                          image:
                              AssetImage('assets/images/etrax_rescue_logo.png'),
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(S.of(context).ACTIVE_MISSIONS,
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                  MissionsList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MissionsList extends StatelessWidget {
  const MissionsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        if (state.initializationData != null) {
          final initializationData = state.initializationData;
          final missions = state.initializationData.missionCollection.missions;
          if (missions.length > 0) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == missions.length)
                    return Divider(height: 1, color: Colors.grey[400]);
                  return InkWell(
                    onTap: () {
                      ExtendedNavigator.of(context).push(
                        '/confirmation-page',
                        arguments: ConfirmationPageArguments(
                          mission: missions[index],
                          states: initializationData.userStateCollection,
                          roles: initializationData.userRoleCollection,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Divider(height: 1, color: Colors.grey[400]),
                        ListTile(
                          title: Text(initializationData
                              .missionCollection.missions[index].name),
                          subtitle: Text(
                            DateFormat.yMd(Intl.systemLocale).format(
                                initializationData
                                    .missionCollection.missions[index].start),
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  );
                },
                childCount: missions.length + 1,
              ),
            );
          }
        }
        return SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CustomMaterialIcons.noList,
                    size: 72,
                    color: Colors.grey,
                  ),
                  Text(
                    S.of(context).NO_MISSIONS,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
