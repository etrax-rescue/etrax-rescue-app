import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../backend/types/etrax_server_endpoints.dart';
import '../../../backend/types/mission_details.dart';
import '../../../generated/l10n.dart';
import '../bloc/home_bloc.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Completer<void> _refreshCompleter = Completer<void>();
  DefaultCacheManager _cacheManager = DefaultCacheManager();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      // This also triggers the onRefresh callback of the RefreshIndicator
      this._refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        BlocProvider.of<HomeBloc>(context).add(Update());
        Scaffold.of(context).hideCurrentSnackBar();
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.missionDetailCollection != null) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
            if (state.missionDetailCollection.details.length > 0) {
              MissionDetailCollection details = state.missionDetailCollection;
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        switch (details.details[index].type) {
                          case DetailType.text:
                            MissionDetailText detail = details.details[index];
                            return ListTile(
                              visualDensity: VisualDensity(
                                  horizontal: VisualDensity.maximumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              title: Text(detail.title),
                              subtitle: Text(detail.body),
                            );
                            break;
                          case DetailType.image:
                            MissionDetailImage detail = details.details[index];
                            if (state.appConnection != null &&
                                state.authenticationData != null) {
                              String imageUrl = state.appConnection
                                      .generateUri(
                                          subPath: EtraxServerEndpoints.image)
                                      .toString() +
                                  '/' +
                                  state.missionState.mission.id.toString() +
                                  '/' +
                                  detail.uid;
                              return CachedNetworkImage(
                                cacheManager: _cacheManager,
                                imageUrl: imageUrl,
                                placeholder: (context, url) => Container(
                                  padding: EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 72,
                                        ),
                                      ),
                                      Center(
                                        child: MaterialButton(
                                          onPressed: () {
                                            _cacheManager.removeFile(imageUrl);
                                            BlocProvider.of<HomeBloc>(context)
                                                .add(Update());
                                          },
                                          child: Text(S.of(context).RETRY),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                httpHeaders: state.authenticationData
                                    .generateAuthHeader(),
                              );
                            } else {
                              return SliverToBoxAdapter();
                            }
                            break;
                          default:
                            return SliverToBoxAdapter();
                            break;
                        }
                      },
                      childCount: details.details.length,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 96,
                      /*child: Text(
                        state.lastupdate != null
                            ? '${S.of(context).LAST_UPDATE}:\n${DateFormat("dd.MM.yyyy - HH:mm:ss\n").format(state.lastupdate)}'
                            : '',
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),*/
                    ),
                  ),
                ],
              );
            } else {
              return CustomScrollView(slivers: [
                SliverFillRemaining(
                  child: Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 72,
                            color: Colors.grey,
                          ),
                          Text(
                            S.of(context).NO_DETAILS,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }
          } else {
            return ListView();
          }
        },
      ),
    );
  }
}
