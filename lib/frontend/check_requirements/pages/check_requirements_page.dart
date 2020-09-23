import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/circular_progress_indicator_icon.dart';
import '../../widgets/custom_material_icons.dart';
import '../../widgets/width_limiter.dart';
import '../cubit/check_requirements_cubit.dart';

enum StatusPageAction {
  change,
  refresh,
  logout,
}

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({
    Key key,
    @required this.state,
    @required this.currentState,
    this.action = StatusPageAction.change,
  }) : super(key: key);

  final UserState state;
  final UserState currentState;
  final StatusPageAction action;

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
  List<Widget> _sequenceWidgets;
  bool _goingBackPossible = true;

  @override
  void initState() {
    super.initState();
    switch (widget.action) {
      case StatusPageAction.change:
        if (widget.state.locationAccuracy == 0) {
          _sequenceWidgets = <Widget>[
            FetchSettingsWidget(listIndex: 0),
            SetStateWidget(listIndex: 1),
            StopUpdatesWidget(listIndex: 2, last: true),
          ];
        } else {
          _sequenceWidgets = <Widget>[
            FetchSettingsWidget(listIndex: 0),
            CheckLocationPermissionWidget(listIndex: 1),
            CheckLocationServicesWidget(listIndex: 2),
            SetStateWidget(listIndex: 3),
            StopUpdatesWidget(listIndex: 4),
            StartUpdatesWidget(listIndex: 5, last: true),
          ];
        }
        break;
      case StatusPageAction.refresh:
        if (widget.state.locationAccuracy == 0) {
          _sequenceWidgets = <Widget>[
            FetchSettingsWidget(listIndex: 0),
            CheckLocationPermissionWidget(listIndex: 1),
            CheckLocationServicesWidget(listIndex: 2),
            StartUpdatesWidget(listIndex: 5, last: true),
          ];
        }
        break;
      case StatusPageAction.logout:
        _sequenceWidgets = <Widget>[
          FetchSettingsWidget(listIndex: 0),
        ];
        if (widget.currentState.locationAccuracy > 0) {
          _sequenceWidgets.addAll([
            LogoutWidget(listIndex: 1),
            StopUpdatesWidget(listIndex: 2, last: true),
          ]);
        } else {
          _sequenceWidgets.add(
            LogoutWidget(listIndex: 1, last: true),
          );
        }
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.bloc<CheckRequirementsCubit>().start(
              widget.state,
              S.of(context).LOCATION_UPDATES_ACTIVE,
              S.of(context).ETRAX_LOCATION_NOTIFICATION,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goingBackPossible;
      },
      child: BlocListener<CheckRequirementsCubit, CheckRequirementsState>(
        listener: (context, state) {
          if (state.status > CheckRequirementsStatus.setState) {
            setState(() {
              _goingBackPossible = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).STATE_HEADING),
            automaticallyImplyLeading: _goingBackPossible,
            actions: [
              IconButton(
                icon: Icon(CustomMaterialIcons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(S.of(context).LOGOUT),
                        content: Text(S.of(context).CONFIRM_LOGOUT),
                        actions: [
                          FlatButton(
                            child: Text(S.of(context).CANCEL),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(S.of(context).YES),
                            onPressed: () {
                              print('logout');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SequenceSliver(steps: _sequenceWidgets),
              SliverFillRemaining(
                hasScrollBody: false,
                child: WidthLimiter(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: BlocBuilder<CheckRequirementsCubit,
                          CheckRequirementsState>(
                        builder: (context, state) {
                          bool enabled = state.status.index ==
                                  CheckRequirementsStatus.complete.index
                              ? true
                              : false;
                          return AbsorbPointer(
                            absorbing: !enabled,
                            child: MaterialButton(
                              color: enabled
                                  ? Theme.of(context).accentColor
                                  : Colors.grey,
                              textColor: Colors.white,
                              onPressed: () {
                                ExtendedNavigator.of(context)
                                    .pushAndRemoveUntil(
                                  Routes.homePage,
                                  (route) => false,
                                  arguments:
                                      HomePageArguments(state: widget.state),
                                );
                              },
                              child: Text(S.of(context).CONTINUE),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorAction extends Equatable {
  ErrorAction({
    @required this.message,
    @required this.buttonLabel,
    @required this.onPressed,
  });

  final String message;
  final String buttonLabel;
  final Function(BuildContext context) onPressed;

  @override
  List<Object> get props => [message, buttonLabel, onPressed];
}

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

class SequenceSliver extends StatelessWidget {
  const SequenceSliver({Key key, @required this.steps}) : super(key: key);

  final List<Widget> steps;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return steps[index];
          },
          childCount: steps.length,
        ),
      ),
    );
  }
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
