import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/missions.dart';

class ConfirmationForm extends StatefulWidget {
  final Mission mission;
  ConfirmationForm({Key key, @required this.mission}) : super(key: key);

  @override
  _ConfirmationFormState createState() =>
      _ConfirmationFormState(mission: mission);
}

class _ConfirmationFormState extends State<ConfirmationForm> {
  final Mission mission;
  final _formKey = GlobalKey<FormState>();

  _ConfirmationFormState({@required this.mission});

  List<String> _functions;

  @override
  void initState() {
    super.initState();
    _functions = ['Hundeführer*in', 'Funker*in'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              S.of(context).MISSION,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_NAME,
            ),
            subtitle: Text(mission.name),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_START,
            ),
            subtitle:
                Text(DateFormat('dd.MM.yyyy - HH:mm').format(mission.start)),
          ),
          ListTile(
            title: Text(
              S.of(context).MISSION_LOCATION,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${S.of(context).LATITUDE}: ${mission.latitude}'),
                Text('${S.of(context).LONGITUDE}: ${mission.longitude}'),
              ],
            ),
            trailing: InkWell(
              child: Icon(Icons.launch),
              onTap: () => MapsLauncher.launchCoordinates(
                  mission.latitude, mission.longitude),
            ),
          ),
          ListTile(
            title: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: S.of(context).FUNCTION,
              ),
              items: _functions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                print(val);
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
      print("validated!");
    }
  }
}
