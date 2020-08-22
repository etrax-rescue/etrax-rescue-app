import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../backend/types/missions.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';

class ConfirmationForm extends StatefulWidget {
  final Mission mission;
  final UserRoleCollection roles;
  final UserStateCollection states;
  ConfirmationForm(
      {Key key,
      @required this.mission,
      @required this.roles,
      @required this.states})
      : super(key: key);

  @override
  _ConfirmationFormState createState() => _ConfirmationFormState();
}

class _ConfirmationFormState extends State<ConfirmationForm> {
  final _formKey = GlobalKey<FormState>();
  int selectedRoleID;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              S.of(context).MISSION,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_NAME,
            ),
            subtitle: Text(widget.mission.name + '\n'),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_START,
            ),
            subtitle: Text(DateFormat('dd.MM.yyyy - HH:mm\n')
                .format(widget.mission.start)),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_LOCATION,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${S.of(context).LATITUDE}: ${widget.mission.latitude}'),
                Text('${S.of(context).LONGITUDE}: ${widget.mission.longitude}'),
              ],
            ),
            trailing: InkWell(
              child: Icon(Icons.launch),
              onTap: () => MapsLauncher.launchCoordinates(
                  widget.mission.latitude, widget.mission.longitude),
            ),
          ),
          ListTile(
            title: DropdownButtonFormField<int>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: S.of(context).FUNCTION,
              ),
              items: widget.roles.roles.map((UserRole role) {
                return DropdownMenuItem<int>(
                  value: role.id,
                  child: Text(role.name),
                );
              }).toList(),
              onChanged: (val) {
                selectedRoleID = val;
              },
              validator: (val) =>
                  val == null ? S.of(context).FIELD_REQUIRED : null,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            title: ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: submit,
                textTheme: ButtonTextTheme.primary,
                child: Text(S.of(context).ACCEPT_MISSION),
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/update-state-page',
          arguments: UpdateStatePageArguments(initial: true));
    }
  }
}
