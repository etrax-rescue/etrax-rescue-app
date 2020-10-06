import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/check_requirements/widgets/complete_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../cubit/check_requirements_cubit.dart';
import '../widgets/continue_button_sliver.dart';
import '../widgets/logout_button.dart';
import '../widgets/sequence_item.dart';
import '../widgets/sequence_sliver.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({
    Key key,
    this.desiredState,
    this.currentState,
    this.action = StatusAction.change,
  }) : super(key: key);

  final UserState desiredState;
  final UserState currentState;
  final StatusAction action;

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: themeData[AppTheme.DarkStatusBar],
      child: BlocProvider(
        create: (_) => sl<CheckRequirementsCubit>(),
        child: this,
      ),
    );
  }

  @override
  _CheckRequirementsPageState createState() => _CheckRequirementsPageState();
}

class _CheckRequirementsPageState extends State<CheckRequirementsPage> {
  bool _goingBackPossible = true;
  Map<SequenceStep, StepContent> _sequenceMap;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.bloc<CheckRequirementsCubit>().start(
              action: widget.action,
              currentState: widget.currentState,
              desiredState: widget.desiredState,
              notificationTitle: S.of(context).LOCATION_UPDATES_ACTIVE,
              notificationBody: S.of(context).ETRAX_LOCATION_NOTIFICATION,
            );
        _sequenceMap = {
          SequenceStep.getSettings: StepContent(
            title: S.of(context).RETRIEVE_SETTINGS_TITLE,
            loadingMessage: S.of(context).RETRIEVING_SETTINGS,
            completeMessage: S.of(context).RETRIEVING_SETTINGS_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().retrieveSettings();
            },
          ),
          SequenceStep.checkPermissions: StepContent(
            title: S.of(context).CHECK_PERMISSIONS_TITLE,
            loadingMessage: S.of(context).CHECKING_PERMISSIONS,
            completeMessage: S.of(context).CHECKING_PERMISSIONS_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            },
          ),
          SequenceStep.checkServices: StepContent(
            title: S.of(context).CHECK_SERVICES_TITLE,
            loadingMessage: S.of(context).CHECKING_SERVICES,
            completeMessage: S.of(context).CHECKING_SERVICES_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            },
          ),
          SequenceStep.getLastLocation: StepContent(
            title: S.of(context).GET_LOCATION_TITLE,
            loadingMessage: S.of(context).GETTING_CURRENT_LOCATION,
            completeMessage: S.of(context).GETTING_CURRENT_LOCATION_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().getLocation();
            },
          ),
          SequenceStep.updateState: StepContent(
            title: S.of(context).UPDATE_STATE_TITLE,
            loadingMessage: S.of(context).UPDATING_STATE,
            completeMessage: S.of(context).UPDATING_STATE_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().updateState();
            },
          ),
          SequenceStep.quickAction: StepContent(
            title: S.of(context).QUICK_ACTION_TITLE,
            loadingMessage: S.of(context).TRIGGERING_QUICK_ACTION,
            completeMessage: S.of(context).TRIGGERING_QUICK_ACTION_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().quickAction();
            },
          ),
          SequenceStep.logout: StepContent(
            title: S.of(context).LOGOUT_TITLE,
            loadingMessage: S.of(context).LOGGING_OUT,
            completeMessage: S.of(context).LOGGING_OUT_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().signout();
            },
          ),
          SequenceStep.stopUpdates: StepContent(
            title: S.of(context).STOP_UPDATES_TITLE,
            loadingMessage: S.of(context).STOPPING_UPDATES,
            completeMessage: S.of(context).STOPPING_UPDATES_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().stopUpdates();
            },
          ),
          SequenceStep.clearState: StepContent(
            title: S.of(context).CLEAR_STATE_TITLE,
            loadingMessage: S.of(context).CLEARING_STATE,
            completeMessage: S.of(context).CLEARING_STATE_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().clearState();
            },
          ),
          SequenceStep.startUpdates: StepContent(
            title: S.of(context).START_UPDATES_TITLE,
            loadingMessage: S.of(context).STARTING_UPDATES,
            completeMessage: S.of(context).STARTING_UPDATES_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().startUpdates();
            },
          ),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goingBackPossible;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).STATE_HEADING),
          automaticallyImplyLeading: _goingBackPossible,
          actions: [LogoutButton()],
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                BlocConsumer<CheckRequirementsCubit, CheckRequirementsState>(
                  listener: (context, state) {
                    setState(() {
                      _goingBackPossible = (state.currentStep?.index ?? 0) <=
                          SequenceStep.updateState.index;
                    });
                    if (state.complete) {
                      delayedPop();
                    }
                  },
                  builder: (context, state) {
                    final stepContent = List<StepContent>.from(
                        state.sequence.map((item) => _sequenceMap[item]));
                    return SequenceSliver(steps: stepContent);
                  },
                ),
              ],
            ),
            CompleteOverlay(),
          ],
        ),
      ),
    );
  }

  void delayedPop() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      if (widget.action == StatusAction.logout) {
        ExtendedNavigator.of(context).pushAndRemoveUntil(
          Routes.loginPage,
          (route) => false,
        );
      } else {
        ExtendedNavigator.of(context).pushAndRemoveUntil(
          Routes.launchPage,
          (route) => false,
        );
      }
    });
  }
}
