import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/widgets/width_limiter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../backend/types/missions.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../bloc/confirmation_bloc.dart';

class ConfirmationPage extends StatefulWidget implements AutoRouteWrapper {
  ConfirmationPage(
      {@required this.mission, @required this.roles, @required this.states});

  final Mission mission;
  final UserRoleCollection roles;
  final UserStateCollection states;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => sl<ConfirmationBloc>(), child: this);
  }

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).CONFIRMATION_HEADING,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText2.color)),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<ConfirmationBloc, ConfirmationState>(
        listener: (context, state) {
          if (state is ConfirmationSuccess) {
            ExtendedNavigator.of(context).push(Routes.checkRequirementsPage,
                arguments: CheckRequirementsPageArguments(
                    state: widget.states.states[0]));
          } else if (state is ConfirmationError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(translateErrorMessage(context, state.messageKey)),
              ),
            );
          }
        },
        child: CustomScrollView(
          physics: PageScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: WidthLimiter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          S.of(context).MISSION,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
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
                            Text(
                                '${S.of(context).LATITUDE}: ${widget.mission.latitude}'),
                            Text(
                                '${S.of(context).LONGITUDE}: ${widget.mission.longitude}'),
                          ],
                        ),
                        trailing: InkWell(
                          child: Icon(Icons.launch),
                          onTap: () => MapsLauncher.launchCoordinates(
                              widget.mission.latitude,
                              widget.mission.longitude),
                        ),
                      ),
                      ListTile(
                        title: DropdownButtonFormField<UserRole>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: S.of(context).FUNCTION,
                          ),
                          items: widget.roles.roles.map((UserRole role) {
                            return DropdownMenuItem<UserRole>(
                              value: role,
                              child: Text(role.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            _selectedRole = val;
                          },
                          validator: (val) =>
                              val == null ? S.of(context).FIELD_REQUIRED : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: WidthLimiter(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: BlocBuilder<ConfirmationBloc, ConfirmationState>(
                        builder: (context, state) {
                          return AnimatedCrossFade(
                            firstChild: ButtonTheme(
                              minWidth: double.infinity,
                              child: MaterialButton(
                                height: 48,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                onPressed: submit,
                                textTheme: ButtonTextTheme.primary,
                                child: Text(S.of(context).ACCEPT_MISSION),
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            secondChild: SizedBox(),
                            crossFadeState: state is ConfirmationInProgress
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 250),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<ConfirmationBloc>(context).add(
          SubmitConfirmation(mission: widget.mission, role: _selectedRole));
    }
  }
}
