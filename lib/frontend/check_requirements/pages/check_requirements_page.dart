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
import '../../widgets/width_limiter.dart';
import '../cubit/check_requirements_cubit.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({Key key, @required this.state}) : super(key: key);

  final UserState state;

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

    if (widget.state.locationAccuracy == 0) {
      _sequenceWidgets = <Widget>[
        FetchSettingsWidget(),
        SetStateWidget(),
        StopUpdatesWidget(),
      ];
    } else {
      _sequenceWidgets = <Widget>[
        FetchSettingsWidget(),
        CheckLocationPermissionWidget(),
        CheckLocationServicesWidget(),
        SetStateWidget(),
        StopUpdatesWidget(),
        StartUpdatesWidget(),
      ];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.bloc<CheckRequirementsCubit>().start(
            widget.state,
            S.of(context).LOCATION_UPDATES_ACTIVE,
            S.of(context).ETRAX_LOCATION_NOTIFICATION,
          );
    });
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

enum WidgetState { inactive, loading, error, success }

class FetchSettingsWidget extends StatelessWidget {
  const FetchSettingsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.settings) {
        widgetState = WidgetState.inactive;
        title = S.of(context).RETRIEVING_SETTINGS;
      } else if (state.status > CheckRequirementsStatus.settings) {
        widgetState = WidgetState.success;
        title = S.of(context).RETRIEVING_SETTINGS_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).RETRIEVING_SETTINGS;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().retrieveSettings();
            };
            break;
          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().retrieveSettings();
            };
            break;
        }
      }
      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class CheckLocationPermissionWidget extends StatelessWidget {
  const CheckLocationPermissionWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.locationPermission) {
        widgetState = WidgetState.inactive;
        title = S.of(context).CHECKING_PERMISSIONS;
      } else if (state.status > CheckRequirementsStatus.locationPermission) {
        widgetState = WidgetState.success;
        title = S.of(context).CHECKING_PERMISSIONS_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).CHECKING_PERMISSIONS;
            break;

          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;

          case CheckRequirementsSubStatus.result1:
            widgetState = WidgetState.error;
            title = S.of(context).LOCATION_PERMISSION_DENIED;
            buttonLabel = S.of(context).RESOLVE;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;

          case CheckRequirementsSubStatus.result2:
            // TODO: add link to settings
            widgetState = WidgetState.error;
            title = S.of(context).LOCATION_PERMISSION_DENIED;
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;

          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;
        }
      }
      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class CheckLocationServicesWidget extends StatelessWidget {
  const CheckLocationServicesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.locationServices) {
        widgetState = WidgetState.inactive;
        title = S.of(context).CHECKING_SERVICES;
      } else if (state.status > CheckRequirementsStatus.locationServices) {
        widgetState = WidgetState.success;
        title = S.of(context).CHECKING_SERVICES_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).CHECKING_SERVICES;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            };
            break;
          case CheckRequirementsSubStatus.result1:
            widgetState = WidgetState.error;
            title = S.of(context).SERVICES_DISABLED;
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            };
            break;
          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            };
            break;
        }
      }

      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class SetStateWidget extends StatelessWidget {
  const SetStateWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.setState) {
        widgetState = WidgetState.inactive;
        title = S.of(context).UPDATING_STATE;
      } else if (state.status > CheckRequirementsStatus.setState) {
        widgetState = WidgetState.success;
        title = S.of(context).UPDATING_STATE_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).UPDATING_STATE;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().updateState();
            };
            break;

          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().updateState();
            };
            break;
        }
      }
      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.logout) {
        widgetState = WidgetState.inactive;
        title = S.of(context).RETRIEVING_SETTINGS;
      } else if (state.status > CheckRequirementsStatus.logout) {
        widgetState = WidgetState.success;
        title = S.of(context).RETRIEVING_SETTINGS_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).LOGOUT;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().signout();
            };
            break;
          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().signout();
            };
            break;
        }
      }
      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class StopUpdatesWidget extends StatelessWidget {
  const StopUpdatesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.stopUpdates) {
        widgetState = WidgetState.inactive;
        title = S.of(context).STOPPING_UPDATES;
      } else if (state.status > CheckRequirementsStatus.stopUpdates) {
        widgetState = WidgetState.success;
        title = S.of(context).STOPPING_UPDATES_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).STOPPING_UPDATES;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().stopUpdates();
            };
            break;
          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().stopUpdates();
            };
            break;
        }
      }

      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class StartUpdatesWidget extends StatelessWidget {
  const StartUpdatesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
      WidgetState widgetState;
      String title;
      String buttonLabel = '';
      Function onPressed = () {};

      if (state.status < CheckRequirementsStatus.startUpdates) {
        widgetState = WidgetState.inactive;
        title = S.of(context).STARTING_UPDATES;
      } else if (state.status > CheckRequirementsStatus.startUpdates) {
        widgetState = WidgetState.success;
        title = S.of(context).STARTING_UPDATES_DONE;
      } else {
        switch (state.subStatus) {
          case CheckRequirementsSubStatus.loading:
            widgetState = WidgetState.loading;
            title = S.of(context).STARTING_UPDATES;
            break;
          case CheckRequirementsSubStatus.failure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().startUpdates();
            };
            break;
          default:
            widgetState = WidgetState.error;
            title =
                translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().startUpdates();
            };
            break;
        }
      }
      return SequenceItem(
        title: title,
        widgetState: widgetState,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      );
    });
  }
}

class SequenceState {
  SequenceState({
    @required this.title,
    @required this.state,
    this.content,
  });

  final String title;
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

class SequenceItem extends StatefulWidget {
  SequenceItem({
    Key key,
    @required this.widgetState,
    @required this.title,
    this.subtitle = 'hello world',
    @required this.buttonLabel,
    @required this.onPressed,
    this.index = 2,
    this.last = false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final WidgetState widgetState;
  final String buttonLabel;
  final VoidCallback onPressed;
  final int index;
  final bool last;

  @override
  _SequenceItemState createState() => _SequenceItemState();
}

class _SequenceItemState extends State<SequenceItem> {
  Widget content;

  Color _currentColor() {
    switch (widget.widgetState) {
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
    Widget icon = Text(widget.index.toString(),
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor));
    switch (widget.widgetState) {
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
    if (widget.widgetState == WidgetState.error) {
      content = MaterialButton(
        onPressed: widget.onPressed,
        color: Theme.of(context).errorColor,
        child: Text(widget.buttonLabel,
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
      );
    } else {
      content = SizedBox();
    }
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
        widget.title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          color: _currentColor(),
        ),
      ),
    ];
    if (widget.widgetState != WidgetState.inactive) {
      children.add(
        Text(
          widget.subtitle,
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
          key: ValueKey(widget.title.hashCode),
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
