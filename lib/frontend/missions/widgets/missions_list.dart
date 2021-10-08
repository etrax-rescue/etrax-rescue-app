// @dart=2.9
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/custom_material_icons.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/missions_bloc.dart';

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
                  return WidthLimiter(
                    child: Container(
                      color: missions[index].exercise
                          ? Colors.lightBlue[50]
                          : Theme.of(context).scaffoldBackgroundColor,
                      child: InkWell(
                        onTap: () {
                          AutoRouter.of(context).push(
                            ConfirmationPageRoute(
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
                                    initializationData.missionCollection
                                        .missions[index].start),
                              ),
                              trailing: Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),
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
