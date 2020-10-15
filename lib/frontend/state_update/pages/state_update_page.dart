import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../check_requirements/cubit/check_requirements_cubit.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/state_update_bloc.dart';

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
        elevation: 0,
        title: Text(
          S.of(context).STATE_HEADING,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocBuilder<StateUpdateBloc, StateUpdateState>(
        builder: (context, state) {
          if (state is FetchingStatesSuccess) {
            List<UserState> stateList = state.states.states;
            bool locationRequired = (_selectedState?.locationAccuracy ?? 0) > 0;
            Widget locationDisclaimer = locationRequired
                ? Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).errorColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      S.of(context).LOCATION_DISCLAIMER,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  )
                : SizedBox();

            return SingleChildScrollView(
              child: WidthLimiter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 4,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(S.of(context).ACTIVE_STATE,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                SizedBox(height: 8),
                                Text(widget.currentState.name),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_downward,
                            size: 48,
                            color: Colors.grey[350],
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(S.of(context).SELECT_STATE,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                SizedBox(height: 16),
                                DropdownButtonFormField<UserState>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      labelText: S.of(context).STATE,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                  items: stateList
                                      .where((state) =>
                                          state != widget.currentState)
                                      .map((UserState userState) {
                                    return DropdownMenuItem<UserState>(
                                      value: userState,
                                      child: Text(userState.name),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    _selectedState = val;
                                    setState(() {});
                                  },
                                  validator: (val) => val == null
                                      ? S.of(context).FIELD_REQUIRED
                                      : null,
                                ),
                                SizedBox(height: 16),
                                AnimatedSwitcher(
                                  duration: kThemeAnimationDuration,
                                  child: locationDisclaimer,
                                  transitionBuilder: (child, animation) {
                                    return SizeTransition(
                                        sizeFactor: animation, child: child);
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: submit,
                                    child: Text(
                                      locationRequired
                                          ? S.of(context).CONTINUE_ANYWAY
                                          : S.of(context).CONTINUE,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
