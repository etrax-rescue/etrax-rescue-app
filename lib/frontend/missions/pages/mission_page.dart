import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../../backend/types/etrax_server_endpoints.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/about_menu_entry.dart';
import '../../widgets/popup_menu.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/missions_list.dart';
import '../widgets/tracking_info.dart';

class MissionPage extends StatefulWidget implements AutoRouteWrapper {
  MissionPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: themeData[AppTheme.LightStatusBar],
      child: BlocProvider(
        create: (_) =>
            sl<InitializationBloc>()..add(StartFetchingInitializationData()),
        child: Scaffold(body: this),
      ),
    );
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
    return BlocListener<InitializationBloc, InitializationState>(
      listener: (context, state) {
        if (state.status == InitializationStatus.inProgress) {
          return;
        }
        if (state.status == InitializationStatus.logout) {
          ExtendedNavigator.of(context).popAndPush(Routes.launchPage);
        }

        _refreshCompleter?.complete();
        _refreshCompleter = Completer();
        if (state.status == InitializationStatus.failure) {
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
        } else if (state.status == InitializationStatus.unrecoverableFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(translateErrorMessage(context, state.messageKey)),
              duration: const Duration(days: 365),
              action: SnackBarAction(
                label: S.of(context).OK,
                onPressed: () {
                  BlocProvider.of<InitializationBloc>(context)
                      .add(LogoutEvent());
                },
              ),
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
              actions: <Widget>[
                PopupMenu(
                  actions: {
                    0: PopupAction(
                      onPressed: () {
                        BlocProvider.of<InitializationBloc>(context)
                            .add(LogoutEvent());
                      },
                      child: Text(S.of(context).LOGOUT),
                    ),
                    1: generateAboutMenuEntry(context),
                  },
                ),
              ],
              expandedHeight: max(MediaQuery.of(context).size.height / 3, 150),
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, MediaQuery.of(context).padding.top + 8, 16, 16),
                  child: BlocBuilder<InitializationBloc, InitializationState>(
                    builder: (context, state) {
                      if (state.appConnection != null &&
                          state.authenticationData != null) {
                        String imageUrl = p.join(
                            state.appConnection
                                .generateUri(
                                    subPath:
                                        EtraxServerEndpoints.organizationLogo)
                                .toString(),
                            state.authenticationData.organizationID);

                        return CachedNetworkImage(
                          width: 200,
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            height: 200,
                          ),
                          errorWidget: (context, url, error) => Image(
                            // Fallback to eTrax Logo
                            image: AssetImage(
                                'assets/images/etrax_rescue_logo.png'),
                            width: 200,
                          ),
                        );
                      }
                      return Image(
                        // Fallback to eTrax Logo
                        image:
                            AssetImage('assets/images/etrax_rescue_logo.png'),
                        width: 200,
                      );
                    },
                  ),
                ),
              ),
            ),
            TrackingInfo(),
            SliverToBoxAdapter(
              child: WidthLimiter(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(S.of(context).MISSIONS_AND_EXERCICES,
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ),
            MissionsList(),
          ],
        ),
      ),
    );
  }
}
