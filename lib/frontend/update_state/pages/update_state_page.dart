import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../backend/domain/entities/user_states.dart';

class UpdateStatePage extends StatefulWidget {
  final bool initial;

  UpdateStatePage({Key key, this.initial = false}) : super(key: key);

  @override
  _UpdateStatePageState createState() => _UpdateStatePageState();
}

class _UpdateStatePageState extends State<UpdateStatePage> {
  final _formKey = GlobalKey<FormState>();
  UserStateCollection states;
  int selectedStateID;

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
    if (widget.initial) {
      // If this is the initial time this dialog is called, automatically select the first state
      selectedStateID = states.states[0].id;
    }
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
              Visibility(
                child: ListTile(
                  title: DropdownButtonFormField<int>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: S.of(context).STATE,
                    ),
                    items: states.states.map((UserState state) {
                      return DropdownMenuItem<int>(
                        value: state.id,
                        child: Text(state.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      selectedStateID = val;
                    },
                    validator: (val) =>
                        val == null ? S.of(context).FIELD_REQUIRED : null,
                  ),
                ),
                visible: !widget.initial,
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
    if (!widget.initial) {
      if (_formKey.currentState.validate()) {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/home-page');
    }
  }
}
