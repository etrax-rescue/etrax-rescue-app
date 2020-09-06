import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
        BlocProvider.of<HomeBloc>(context).add(UpdateMissionDetails());
        Scaffold.of(context).hideCurrentSnackBar();
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.missionDetailCollection != null) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
            if (state.missionDetailCollection.details.length > 0) {
              MissionDetailCollection details = state.missionDetailCollection;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: details.details.length,
                itemBuilder: (BuildContext context, int index) {
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
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
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
                                          .add(UpdateMissionDetails());
                                    },
                                    child: Text(S.of(context).RETRY),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          httpHeaders:
                              state.authenticationData.generateAuthHeader(),
                        );
                      } else {
                        return ListView();
                      }
                      break;
                    default:
                      return ListView();
                      break;
                  }
                },
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Center(
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
              );
            }
          } else {
            return ListView();
          }
        },
      ),
    );
  }
}
