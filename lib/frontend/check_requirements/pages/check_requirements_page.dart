import 'package:auto_route/auto_route.dart';
import 'package:background_location/background_location.dart';
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
  List<Widget> widgetSequence = [
    FetchSettingsWidget(),
    CheckLocationPermissionWidget(),
    CheckLocationServicesWidget(),
    SetStateWidget(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.bloc<CheckRequirementsCubit>().userState = widget.state;
      context.bloc<CheckRequirementsCubit>().retrieveSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: BlocListener<CheckRequirementsCubit, CheckRequirementsState>(
        listener: (context, state) {
          print(state);
          if (state is SetStateSuccess) {
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.homePage,
              (route) => false,
              arguments: HomePageArguments(state: widget.state),
            );
          }
        },
        child: Center(
          child: ListView(
            children: widgetSequence,
          ),
        ),
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
      if (state < RetrievingSettingsState()) {
        widgetState = WidgetState.inactive;
      } else if (state > RetrievingSettingsState()) {
        widgetState = WidgetState.success;
      } else if (state is RetrievingSettingsInProgress) {
        widgetState = WidgetState.loading;
      } else if (state is RetrievingSettingsSuccess) {
        widgetState = WidgetState.success;
      }
      return SequenceItem(
        title: S.of(context).RETRIEVING_SETTINGS,
        widgetState: widgetState,
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
      if (state < LocationPermissionState()) {
        widgetState = WidgetState.inactive;
      } else if (state > LocationPermissionState()) {
        widgetState = WidgetState.success;
      } else if (state is LocationPermissionInProgress) {
        widgetState = WidgetState.loading;
      } else if (state is LocationPermissionResult) {
        switch (state.permissionStatus) {
          case PermissionStatus.granted:
            widgetState = WidgetState.success;
            break;
          case PermissionStatus.denied:
            return SequenceItem(
              title: S.of(context).LOCATION_PERMISSION_DENIED,
              widgetState: WidgetState.error,
              buttonLabel: S.of(context).RESOLVE,
              onPressed: () {
                print('resolving');
                context
                    .bloc<CheckRequirementsCubit>()
                    .locationPermissionCheck();
              },
            );
            break;
          case PermissionStatus.deniedForever:
            return SequenceItem(
              title: S.of(context).LOCATION_PERMISSION_DENIED_FOREVER,
              widgetState: WidgetState.error,
              buttonLabel: S.of(context).RETRY,
              onPressed: () {
                context
                    .bloc<CheckRequirementsCubit>()
                    .locationPermissionCheck();
              },
            );
            break;
        }
      }
      return SequenceItem(
        title: S.of(context).CHECKING_PERMISSIONS,
        widgetState: widgetState,
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
      if (state < LocationServicesState()) {
        widgetState = WidgetState.inactive;
      } else if (state > LocationServicesState()) {
        widgetState = WidgetState.success;
      } else if (state is LocationServicesInProgress) {
        widgetState = WidgetState.loading;
      } else if (state is LocationServicesResult) {
        if (state.enabled == true) {
          widgetState = WidgetState.success;
        } else {
          widgetState = WidgetState.error;
          return SequenceItem(
            title: S.of(context).SERVICES_DISABLED,
            widgetState: WidgetState.error,
            buttonLabel: S.of(context).RESOLVE,
            onPressed: () {
              context.bloc<CheckRequirementsCubit>().locationServicesCheck();
            },
          );
        }
      }
      return SequenceItem(
        title: S.of(context).CHECKING_SERVICES,
        widgetState: widgetState,
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
      if (state < SetStateState()) {
        widgetState = WidgetState.inactive;
      } else if (state > SetStateState()) {
        widgetState = WidgetState.success;
      } else if (state is SetStateInProgress) {
        widgetState = WidgetState.loading;
      } else if (state is SetStateSuccess) {
        widgetState = WidgetState.success;
      }
      return SequenceItem(
        title: S.of(context).CHECKING_SERVICES,
        widgetState: widgetState,
      );
    });
  }
}

class CircularProgressIndicatorIcon extends StatelessWidget {
  const CircularProgressIndicatorIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Theme.of(context).textTheme.bodyText1.fontSize,
      width: Theme.of(context).textTheme.bodyText1.fontSize,
      child: CircularProgressIndicator(),
    );
  }
}

/*
class SequenceItem extends StatefulWidget {
  SequenceItem(
      {Key key,
      @required this.widgetState,
      @required this.title,
      this.buttonLabel,
      this.onPressed})
      : super(key: key);

  final String title;
  final WidgetState widgetState;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  _SequenceItemState createState() => _SequenceItemState();
}

class _SequenceItemState extends State<SequenceItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Opacity(
        opacity: widget.widgetState == WidgetState.inactive ? 0.4 : 1.0,
        child: ListTile(
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize),
          ),
          leading: Builder(
            builder: (context) {
              switch (widget.widgetState) {
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
              if (widget.widgetState == WidgetState.error) {
                return MaterialButton(
                  onPressed: widget.onPressed ?? emptyCallback,
                  child: Text(widget.buttonLabel ?? '',
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

  static void emptyCallback() {}
}
*/

class SequenceItem extends StatelessWidget {
  const SequenceItem(
      {Key key,
      @required this.widgetState,
      @required this.title,
      this.buttonLabel,
      this.onPressed})
      : super(key: key);

  final String title;
  final WidgetState widgetState;
  final String buttonLabel;
  final VoidCallback onPressed;

  static void emptyCallback() {}

  @override
  Widget build(BuildContext context) {
    return Opacity(
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
                onPressed: onPressed ?? emptyCallback,
                child: Text(buttonLabel ?? '',
                    style: TextStyle(color: Colors.yellow[700])),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
