import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/mission_details.dart';
import '../../../generated/l10n.dart';
import '../bloc/home_bloc.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        BlocProvider.of<HomeBloc>(context).add(UpdateMissionDetails());
        Scaffold.of(context).hideCurrentSnackBar();
        return _refreshCompleter.future;
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();

          if (state.missionDetailCollection != null) {
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
                        title: Text(detail.title),
                        subtitle: Text(detail.body),
                      );
                      break;
                    case DetailType.image:
                      MissionDetailImage detail = details.details[index];
                      if (state.appConnection != null &&
                          state.authenticationData != null) {
                        return CachedNetworkImage(
                          imageUrl: state.appConnection
                                  .generateUri(
                                      subPath: EtraxServerEndpoints.image)
                                  .toString() +
                              '/' +
                              detail.uid,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          httpHeaders:
                              state.authenticationData.generateAuthHeader(),
                        );
                      } else {
                        return Container();
                      }
                      break;
                    default:
                      return Container();
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
