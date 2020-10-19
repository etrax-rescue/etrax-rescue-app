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
        //elevation: 0,
        title: Text(
          S.of(context).STATE_HEADING,
        ),
        bottom: PreferredSize(
          preferredSize: Size(
            double.infinity,
            Theme.of(context).textTheme.bodyText2.fontSize + 8,
          ),
          child: Container(
            color: Theme.of(context).accentColor,
            height: Theme.of(context).textTheme.bodyText2.fontSize + 8,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(
                S.of(context).STATUS_DISPLAY + widget.currentState.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: WidthLimiter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).SELECT_STATE,
                                style: Theme.of(context).textTheme.headline5),
                            SizedBox(height: 16),
                            DropdownButtonFormField<UserState>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                  labelText: S.of(context).STATE,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              items: stateList
                                  .where(
                                      (state) => state != widget.currentState)
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
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
                          child: Text(locationRequired
                              ? S.of(context).CONTINUE_ANYWAY
                              : S.of(context).CONTINUE),
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void submit() {
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
