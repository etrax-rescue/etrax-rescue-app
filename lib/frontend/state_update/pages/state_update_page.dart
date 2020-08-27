import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../routes/router.gr.dart';

class StateUpdatePage extends StatefulWidget {
  StateUpdatePage({Key key}) : super(key: key);

  @override
  _StateUpdatePageState createState() => _StateUpdatePageState();
}

class _StateUpdatePageState extends State<StateUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  UserStateCollection states;
  UserState _selectedState;

  @override
  void initState() {
    super.initState();
    states = UserStateCollection(
      states: [
        UserState(
          id: 1,
          name: 'Anreise',
          description: 'Auf dem Weg',
          locationAccuracy: 3,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  S.of(context).STATE,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              ListTile(
                title: DropdownButtonFormField<UserState>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: S.of(context).STATE,
                  ),
                  items: states.states.map((UserState state) {
                    return DropdownMenuItem<UserState>(
                      value: state,
                      child: Text(state.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    _selectedState = val;
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
                    child: Text(S.of(context).UPDATE_STATE),
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    // TODO: implement logic to update mission data
    if (_formKey.currentState.validate()) {
      ExtendedNavigator.of(context).popAndPush(Routes.checkRequirementsPage,
          arguments: CheckRequirementsPageArguments(state: _selectedState));
    }
  }
}
