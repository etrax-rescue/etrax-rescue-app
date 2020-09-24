import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/circular_progress_indicator_icon.dart';
import '../../widgets/width_limiter.dart';
import '../cubit/check_requirements_cubit.dart';
import '../widgets/continue_button_sliver.dart';
import '../widgets/logout_button.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({
    Key key,
    @required this.desiredState,
    @required this.currentState,
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
          SequenceStep.updateState: StepContent(
            title: S.of(context).UPDATE_STATE_TITLE,
            loadingMessage: S.of(context).UPDATING_STATE,
            completeMessage: S.of(context).UPDATING_STATE_DONE,
            onRetry: (context) {
              context.bloc<CheckRequirementsCubit>().updateState();
            },
          ),
          SequenceStep.logout: StepContent(
            title: S.of(context).LOGOUT,
            loadingMessage: 'Logging out...',
            completeMessage: 'Logged out',
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
            title: 'clearState',
            loadingMessage: 'Clearing state...',
            completeMessage: 'State cleared',
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
        body: CustomScrollView(
          slivers: <Widget>[
            BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
              builder: (context, state) {
                final stepContent = List<StepContent>.from(
                    state.sequence.map((item) => _sequenceMap[item]));
                return SequenceSliver(steps: stepContent);
              },
            ),
            ContinueButtonSliver(
              onPressed: () {
                ExtendedNavigator.of(context).pushAndRemoveUntil(
                  Routes.homePage,
                  (route) => false,
                  arguments: HomePageArguments(state: widget.desiredState),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SequenceWidget extends StatelessWidget {
  const SequenceWidget({
    Key key,
    @required this.index,
    @required this.stepContent,
  }) : super(key: key);

  final int index;
  final StepContent stepContent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
      builder: (context, state) {
        final status = state.sequenceStatus[index];
        String subtitle;
        switch (status) {
          case StepStatus.disabled:
            break;
          case StepStatus.loading:
            subtitle = stepContent.loadingMessage;
            break;
          case StepStatus.failure:
            subtitle = translateErrorMessage(context, state.messageKey);
            break;
          case StepStatus.complete:
            subtitle = stepContent.completeMessage;
            break;
        }

        return Column(
          children: [
            Text(stepContent.title,
                style: Theme.of(context).textTheme.subtitle2),
            Text(subtitle ?? ''),
            SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class RetryButton extends StatelessWidget {
  const RetryButton({Key key, @required this.onPressed}) : super(key: key);

  final Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(context),
      color: Theme.of(context).errorColor,
      child: Text(
        S.of(context).RETRY,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}

class StepContent {
  const StepContent({
    @required this.title,
    @required this.onRetry,
    @required this.loadingMessage,
    @required this.completeMessage,
  });

  final String title;
  final Function(BuildContext) onRetry;
  final String loadingMessage;
  final String completeMessage;
}

class SequenceSliver extends StatelessWidget {
  const SequenceSliver({Key key, @required this.steps}) : super(key: key);

  final List<StepContent> steps;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(8),
      sliver: BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SequenceWidget(
                  index: index,
                  stepContent: steps[index],
                );
              },
              childCount: state.sequence.length,
            ),
          );
        },
      ),
    );
  }
}

/*
class FetchSettingsWidget extends StatelessWidget {
  const FetchSettingsWidget({Key key, @required this.listIndex})
      : super(key: key);

  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final settingsSequenceMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).RETRIEVE_SETTINGS_TITLE,
          subtitle: S.of(context).RETRIEVING_SETTINGS,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).RETRIEVE_SETTINGS_TITLE,
          subtitle: S.of(context).RETRIEVING_SETTINGS_ERROR,
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().retrieveSettings();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).RETRIEVE_SETTINGS_TITLE,
          subtitle: S.of(context).RETRIEVING_SETTINGS_DONE,
          state: WidgetState.success,
        ),
      };
      return SequenceItem(
        ownStatus: CheckRequirementsStatus.settings,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
        sequenceStateMap: settingsSequenceMap,
      );
    });
  }
}

class CheckLocationPermissionWidget extends StatelessWidget {
  const CheckLocationPermissionWidget({Key key, @required this.listIndex})
      : super(key: key);

  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final locationPermissionMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).CHECK_PERMISSIONS_TITLE,
          subtitle: S.of(context).CHECKING_PERMISSIONS,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).CHECK_PERMISSIONS_TITLE,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.result1: SequenceState(
          title: S.of(context).CHECK_PERMISSIONS_TITLE,
          subtitle: S.of(context).LOCATION_PERMISSION_DENIED,
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.result2: SequenceState(
          title: S.of(context).CHECK_PERMISSIONS_TITLE,
          subtitle: S.of(context).LOCATION_PERMISSION_DENIED_FOREVER,
          state: WidgetState.error,
          // TODO: add link to settings
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).CHECK_PERMISSIONS_TITLE,
          subtitle: S.of(context).CHECKING_PERMISSIONS_DONE,
          state: WidgetState.success,
        ),
      };
      return SequenceItem(
        sequenceStateMap: locationPermissionMap,
        ownStatus: CheckRequirementsStatus.locationPermission,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
      );
    });
  }
}

class CheckLocationServicesWidget extends StatelessWidget {
  const CheckLocationServicesWidget({Key key, @required this.listIndex})
      : super(key: key);

  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final locationServicesMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).CHECK_SERVICES_TITLE,
          subtitle: S.of(context).CHECKING_SERVICES,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).CHECK_SERVICES_TITLE,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.result1: SequenceState(
          title: S.of(context).CHECK_SERVICES_TITLE,
          subtitle: S.of(context).CHECKING_SERVICES_ERROR,
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).CHECK_SERVICES_TITLE,
          subtitle: S.of(context).CHECKING_SERVICES_DONE,
          state: WidgetState.success,
        ),
      };

      return SequenceItem(
        sequenceStateMap: locationServicesMap,
        ownStatus: CheckRequirementsStatus.locationServices,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
      );
    });
  }
}

class SetStateWidget extends StatelessWidget {
  const SetStateWidget({Key key, @required this.listIndex}) : super(key: key);

  final int listIndex;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final setStateMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).UPDATE_STATE_TITLE,
          subtitle: S.of(context).UPDATING_STATE,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).UPDATE_STATE_TITLE,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().updateState();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).UPDATE_STATE_TITLE,
          subtitle: S.of(context).UPDATING_STATE_DONE,
          state: WidgetState.success,
        ),
      };
      return SequenceItem(
        sequenceStateMap: setStateMap,
        ownStatus: CheckRequirementsStatus.setState,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
      );
    });
  }
}

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key key, @required this.listIndex, this.last = false})
      : super(key: key);

  final int listIndex;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final logoutMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).LOGOUT,
          subtitle: S.of(context).LOGOUT,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).LOGOUT,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().signout();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).LOGOUT,
          subtitle: S.of(context).LOGOUT,
          state: WidgetState.success,
        ),
      };
      return SequenceItem(
        sequenceStateMap: logoutMap,
        ownStatus: CheckRequirementsStatus.logout,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
        last: last,
      );
    });
  }
}

class StopUpdatesWidget extends StatelessWidget {
  const StopUpdatesWidget(
      {Key key, @required this.listIndex, this.last = false})
      : super(key: key);

  final int listIndex;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final stopUpdatesMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).STOP_UPDATES_TITLE,
          subtitle: S.of(context).STOPPING_UPDATES,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).STOP_UPDATES_TITLE,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().stopUpdates();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).STOP_UPDATES_TITLE,
          subtitle: S.of(context).STOPPING_UPDATES_DONE,
          state: WidgetState.loading,
        ),
      };

      return SequenceItem(
        sequenceStateMap: stopUpdatesMap,
        ownStatus: CheckRequirementsStatus.stopUpdates,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
        last: last,
      );
    });
  }
}

class StartUpdatesWidget extends StatelessWidget {
  const StartUpdatesWidget(
      {Key key, @required this.listIndex, @required this.last})
      : super(key: key);

  final int listIndex;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      final startUpdatesMap = {
        CheckRequirementsSubStatus.loading: SequenceState(
          title: S.of(context).START_UPDATES_TITLE,
          subtitle: S.of(context).STARTING_UPDATES,
          state: WidgetState.loading,
        ),
        CheckRequirementsSubStatus.failure: SequenceState(
          title: S.of(context).START_UPDATES_TITLE,
          subtitle: translateErrorMessage(context, state.messageKey),
          state: WidgetState.error,
          content: MaterialButton(
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().startUpdates();
            },
            color: Theme.of(context).errorColor,
            child: Text(
              S.of(context).RETRY,
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
        CheckRequirementsSubStatus.success: SequenceState(
          title: S.of(context).START_UPDATES_TITLE,
          subtitle: S.of(context).STARTING_UPDATES_DONE,
          state: WidgetState.success,
        ),
      };
      return SequenceItem(
        sequenceStateMap: startUpdatesMap,
        ownStatus: CheckRequirementsStatus.startUpdates,
        currentStatus: state.status,
        subStatus: state.subStatus,
        listIndex: listIndex,
        last: last,
      );
    });
  }
}

class SequenceState {
  SequenceState({
    @required this.title,
    @required this.subtitle,
    @required this.state,
    this.content,
  });

  final String title;
  final String subtitle;
  final Widget content;
  final WidgetState state;
}

enum WidgetState { inactive, loading, error, success }

class SequenceItem extends StatefulWidget {
  SequenceItem({
    Key key,
    @required this.ownStatus,
    @required this.currentStatus,
    @required this.sequenceStateMap,
    @required this.subStatus,
    @required this.listIndex,
    this.last = false,
  }) : super(key: key);

  final CheckRequirementsStatus ownStatus;
  final CheckRequirementsStatus currentStatus;
  final CheckRequirementsSubStatus subStatus;

  final Map<CheckRequirementsSubStatus, SequenceState> sequenceStateMap;

  final int listIndex;
  final bool last;

  @override
  _SequenceItemState createState() => _SequenceItemState();
}

class _SequenceItemState extends State<SequenceItem> {
  CheckRequirementsSubStatus get subStatus {
    if (widget.ownStatus < widget.currentStatus) {
      return CheckRequirementsSubStatus.success;
    } else if (widget.ownStatus > widget.currentStatus) {
      return CheckRequirementsSubStatus.loading;
    }
    return widget.subStatus;
  }

  SequenceState get sequenceState {
    return widget.sequenceStateMap[subStatus];
  }

  String get title {
    return sequenceState?.title ?? '';
  }

  String get subtitle {
    return sequenceState?.subtitle ?? '';
  }

  Widget get content {
    return sequenceState?.content ?? SizedBox();
  }

  WidgetState get state {
    if (widget.ownStatus < widget.currentStatus) {
      return WidgetState.success;
    } else if (widget.ownStatus > widget.currentStatus) {
      return WidgetState.inactive;
    }
    return sequenceState?.state ?? WidgetState.error;
  }

  Color _currentColor() {
    switch (state) {
      case WidgetState.inactive:
        return Theme.of(context).disabledColor;
        break;
      case WidgetState.loading:
        break;
      case WidgetState.error:
        return Theme.of(context).errorColor;
        break;
      case WidgetState.success:
        break;
    }
    return Theme.of(context).primaryColor;
  }

  Widget _buildIcon() {
    Widget icon = Text((widget.listIndex + 1).toString(),
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor));
    switch (state) {
      case WidgetState.inactive:
        break;
      case WidgetState.loading:
        icon = CircularProgressIndicatorIcon(
            size: 24, color: Theme.of(context).scaffoldBackgroundColor);
        break;
      case WidgetState.error:
        icon = Icon(Icons.warning,
            size: 20, color: Theme.of(context).scaffoldBackgroundColor);
        break;
      case WidgetState.success:
        icon = Icon(Icons.check,
            size: 24, color: Theme.of(context).scaffoldBackgroundColor);
        break;
    }
    return icon;
  }

  Widget _buildCircle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: _currentColor(),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: _buildIcon(),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: content,
      transitionBuilder: (child, animation) {
        return SizeTransition(sizeFactor: animation, child: child);
      },
    );
  }

  Widget _buildHeading() {
    List<Widget> children = [
      Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          color: _currentColor(),
        ),
      ),
    ];
    if (state != WidgetState.inactive) {
      children.add(
        Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      );
    }
    return Expanded(
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: Column(
          key: ValueKey(title.hashCode),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        transitionBuilder: (widget, animation) {
          return Container(
            alignment: Alignment.centerLeft,
            child: FadeTransition(opacity: animation, child: widget),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidthLimiter(
      child: Column(
        children: [
          Row(
            children: [
              _buildCircle(),
              SizedBox(width: 8),
              _buildHeading(),
            ],
          ),
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(minHeight: 18),
            margin: EdgeInsets.only(left: 16),
            decoration: widget.last
                ? BoxDecoration()
                : BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
            padding: EdgeInsets.only(left: 20),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}
*/
