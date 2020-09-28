import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/check_requirements/cubit/check_requirements_cubit.dart';
import 'package:etrax_rescue_app/frontend/state_update/bloc/state_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';

class StateUpdatePage extends StatefulWidget implements AutoRouteWrapper {
  StateUpdatePage({Key key, @required this.currentState}) : super(key: key);

  final UserState currentState;

  @override
  _StateUpdatePageState createState() => _StateUpdatePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: themeData[AppTheme.DarkStatusBar],
      child: BlocProvider(
        create: (_) => sl<StateUpdateBloc>()..add(FetchStates()),
        child: this,
      ),
    );
  }
}

class _StateUpdatePageState extends State<StateUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  UserState _selectedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: BlocBuilder<StateUpdateBloc, StateUpdateState>(
        builder: (context, state) {
          if (state is FetchingStatesSuccess) {
            List<UserState> stateList = state.states.states;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        S.of(context).STATE,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      title: Text(S.of(context).ACTIVE_STATE),
                      subtitle: Text(widget.currentState.name),
                    ),
                    ListTile(
                      title: DropdownButtonFormField<UserState>(
                          //value: widget.currentState,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: S.of(context).STATE,
                          ),
                          items: stateList
                              .where((state) => state.id <= 11)
                              .where((state) => state != widget.currentState)
                              .map((UserState userState) {
                            return DropdownMenuItem<UserState>(
                              value: userState,
                              child: Text(userState.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            _selectedState = val;
                          },
                          validator: (val) => val == null
                              ? S.of(context).FIELD_REQUIRED
                              : null),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          child: MaterialButton(
                            height: 48,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            onPressed: submit,
                            textTheme: ButtonTextTheme.primary,
                            child: Text(S.of(context).UPDATE_STATE),
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void submit() {
    // TODO: implement logic to update mission data
    if (_formKey.currentState.validate()) {
      ExtendedNavigator.of(context).popAndPush(
        Routes.checkRequirementsPage,
        arguments: CheckRequirementsPageArguments(
          currentState: widget.currentState,
          desiredState: _selectedState,
          action: StatusAction.change,
        ),
      );
    }
  }
}
