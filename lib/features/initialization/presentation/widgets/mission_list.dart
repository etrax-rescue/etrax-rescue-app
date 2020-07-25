import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../routes/router.gr.dart';
import '../../domain/entities/missions.dart';

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
            onTap: () {
              ExtendedNavigator.of(context).push('/confirmation-page',
                  arguments: ConfirmationPageArguments(
                      mission: missionCollection.missions[index]));
            },
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
