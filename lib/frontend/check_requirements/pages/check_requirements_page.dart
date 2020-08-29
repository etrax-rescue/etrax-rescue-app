import 'package:auto_route/auto_route.dart';
import 'package:background_location/background_location.dart';
import 'package:etrax_rescue_app/frontend/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/frontend/widgets/width_limiter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../cubit/check_requirements_cubit.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({Key key, @required this.state}) : super(key: key);

  final UserState state;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckRequirementsCubit>(),
      child: this,
    );
  }

  @override
  _CheckRequirementsPageState createState() => _CheckRequirementsPageState();
}

class _CheckRequirementsPageState extends State<CheckRequirementsPage> {
  List<Widget> _sequenceWidgets;

  @override
  void initState() {
    super.initState();
    if (widget.state.locationAccuracy == 0) {
      _sequenceWidgets = <Widget>[
        FetchSettingsWidget(),
        CheckLocationPermissionWidget(),
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
            widget.state.name,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(_sequenceWidgets),
          ),
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
                              CheckRequirementsStatus.success.index
                          ? true
                          : false;
                      return AbsorbPointer(
                        absorbing: !enabled,
                        child: MaterialButton(
                          onPressed: () {
                            ExtendedNavigator.of(context).pushAndRemoveUntil(
                              Routes.homePage,
                              (route) => false,
                              arguments: HomePageArguments(state: widget.state),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.of(context).CONTINUE,
                                style: TextStyle(
                                  color: enabled
                                      ? Theme.of(context).accentColor
                                      : Colors.grey,
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: enabled
                                      ? Theme.of(context).accentColor
                                      : Colors.grey),
                            ],
                          ),
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
    );
  }
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

      if (state.status < CheckRequirementsStatus.settingsLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).RETRIEVING_SETTINGS;
      } else if (state.status >= CheckRequirementsStatus.settingsSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).RETRIEVING_SETTINGS_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.settingsLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).RETRIEVING_SETTINGS;
            break;
          case CheckRequirementsStatus.settingsFailure:
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

      if (state.status < CheckRequirementsStatus.locationPermissionLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).CHECKING_PERMISSIONS;
      } else if (state.status >=
          CheckRequirementsStatus.locationPermissionSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).CHECKING_PERMISSIONS_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.locationPermissionLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).CHECKING_PERMISSIONS;
            break;

          case CheckRequirementsStatus.locationPermissionFailure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;

          case CheckRequirementsStatus.locationPermissionDenied:
            widgetState = WidgetState.error;
            title = S.of(context).LOCATION_PERMISSION_DENIED;
            buttonLabel = S.of(context).RESOLVE;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationPermissionCheck();
            };
            break;

          case CheckRequirementsStatus.locationPermissionDeniedForever:
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

      if (state.status < CheckRequirementsStatus.locationServicesLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).CHECKING_SERVICES;
      } else if (state.status >=
          CheckRequirementsStatus.locationServicesSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).CHECKING_SERVICES_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.locationServicesLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).CHECKING_SERVICES;
            break;
          case CheckRequirementsStatus.locationServicesFailure:
            widgetState = WidgetState.error;
            title = translateErrorMessage(context, state.messageKey);
            buttonLabel = S.of(context).RETRY;
            onPressed = () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            };
            break;
          case CheckRequirementsStatus.locationServicesDisabled:
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

      if (state.status < CheckRequirementsStatus.setStateLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).UPDATING_STATE;
      } else if (state.status >= CheckRequirementsStatus.setStateSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).UPDATING_STATE_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.setStateLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).UPDATING_STATE;
            break;
          case CheckRequirementsStatus.setStateFailure:
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

      if (state.status < CheckRequirementsStatus.stopUpdatesLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).STOPPING_UPDATES;
      } else if (state.status >= CheckRequirementsStatus.stopUpdatesSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).STOPPING_UPDATES_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.stopUpdatesLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).STOPPING_UPDATES;
            break;
          case CheckRequirementsStatus.stopUpdatesFailure:
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

      if (state.status < CheckRequirementsStatus.startUpdatesLoading) {
        widgetState = WidgetState.inactive;
        title = S.of(context).STARTING_UPDATES;
      } else if (state.status >= CheckRequirementsStatus.startUpdatesSuccess) {
        widgetState = WidgetState.success;
        title = S.of(context).STARTING_UPDATES_DONE;
      } else {
        switch (state.status) {
          case CheckRequirementsStatus.startUpdatesLoading:
            widgetState = WidgetState.loading;
            title = S.of(context).STARTING_UPDATES;
            break;
          case CheckRequirementsStatus.startUpdatesFailure:
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

class CircularProgressIndicatorIcon extends StatelessWidget {
  const CircularProgressIndicatorIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Theme.of(context).textTheme.bodyText2.fontSize,
      width: Theme.of(context).textTheme.bodyText2.fontSize,
      child: CircularProgressIndicator(),
    );
  }
}

class SequenceItem extends StatelessWidget {
  const SequenceItem(
      {Key key,
      @required this.widgetState,
      @required this.title,
      @required this.buttonLabel,
      @required this.onPressed})
      : super(key: key);

  final String title;
  final WidgetState widgetState;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return WidthLimiter(
      child: Opacity(
        opacity: widgetState == WidgetState.inactive ? 0.4 : 1.0,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize),
          ),
          leading: Builder(
            builder: (context) {
              switch (widgetState) {
                case WidgetState.inactive:
                  return SizedBox(
                    height: Theme.of(context).textTheme.bodyText1.fontSize,
                  );
                  break;
                case WidgetState.loading:
                  return CircularProgressIndicatorIcon();
                  break;
                case WidgetState.error:
                  return Icon(Icons.warning, color: Colors.yellow[700]);
                  break;
                case WidgetState.success:
                  return Icon(Icons.check, color: Colors.green);
                  break;
              }
              return SizedBox(
                height: Theme.of(context).textTheme.bodyText1.fontSize,
              );
            },
          ),
          trailing: Builder(
            builder: (context) {
              if (widgetState == WidgetState.error) {
                return MaterialButton(
                  onPressed: onPressed,
                  child: Text(buttonLabel,
                      style: TextStyle(color: Colors.yellow[700])),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
