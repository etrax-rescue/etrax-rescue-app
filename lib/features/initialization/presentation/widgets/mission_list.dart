import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/initialization_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../routes/router.gr.dart';

class MissionList extends StatelessWidget {
  final InitializationData initializationData;
  const MissionList({Key key, this.initializationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: initializationData.missionCollection.missions.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            onTap: () {
              ExtendedNavigator.of(context).push('/confirmation-page',
                  arguments: ConfirmationPageArguments(
                      mission:
                          initializationData.missionCollection.missions[index],
                      states: initializationData.userStateCollection,
                      roles: initializationData.userRoleCollection));
            },
            child: ListTile(
              title: Text(
                  initializationData.missionCollection.missions[index].name),
              subtitle: Text(DateFormat('dd.MM.yyyy - HH:mm').format(
                  initializationData.missionCollection.missions[index].start)),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}
