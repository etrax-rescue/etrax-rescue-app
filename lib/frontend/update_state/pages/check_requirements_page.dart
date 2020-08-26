import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../bloc/update_state_bloc.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  final UserState state;
  CheckRequirementsPage({Key key, @required this.state}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UpdateStateBloc>()..add(SubmitState(state: state)),
      child: this,
    );
  }

  @override
  _CheckRequirementsPageState createState() => _CheckRequirementsPageState();
}

class _CheckRequirementsPageState extends State<CheckRequirementsPage> {
  List<Status> _steps = [];

  @override
  void initState() {
    super.initState();

    // We build the _steps list only after the build context is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _steps = [
          Status(message: S.of(context).CHECKING_PERMISSIONS),
          Status(message: S.of(context).CHECKING_SERVICES),
          Status(message: S.of(context).UPDATING_STATE),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: BlocListener<UpdateStateBloc, UpdateStateState>(
        listener: (context, state) {
          print(state);
          if (state is CheckingPermissionInProgress) {
            _steps[StepIndex.CHECKING_PERMISSION].visible = true;
          } else if (state is LocationPermissionGranted) {
            _steps[StepIndex.CHECKING_PERMISSION].code = 1;
          } else if (state is CheckingLocationServicesInProgress) {
            _steps[StepIndex.CHECKING_SERVICES].visible = true;
          } else if (state is LocationServicesEnabled) {
            _steps[StepIndex.CHECKING_SERVICES].code = 1;
          } else if (state is UpdateStateInProgress) {
            _steps[StepIndex.UPDATING_STATE].visible = true;
          } else if (state is UpdateStateSuccess) {
            _steps[StepIndex.UPDATING_STATE].code = 1;
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.homePage,
              (route) => false,
              arguments: HomePageArguments(state: widget.state),
            );
          }
          // TODO: Use BlocBuilder instead?
          setState(() {});
        },
        child: Center(
          child: ListView.builder(
            itemCount: _steps.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              Widget tile = ListTile(
                title: Text(_steps[index].message),
                trailing: Builder(
                  builder: (context) {
                    if (_steps[index].visible == true) {
                      if (_steps[index].code == 0) {
                        return CircularProgressIndicator();
                      } else if (_steps[index].code == 1) {
                        return Icon(
                          Icons.check,
                          color: Colors.green,
                        );
                      } else if (_steps[index].code == 2) {
                        return MaterialButton(
                          onPressed: () => _resolve(index, _steps[index].code),
                          child: Text(S.of(context).RESOLVE),
                        );
                      }
                      return Icon(
                        Icons.warning,
                        color: Colors.yellow,
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              );
              if (_steps[index].visible == true) {
                return tile;
              } else {
                return Opacity(
                  opacity: 0.3,
                  child: tile,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _resolve(int index, int state) {
    print('resolve');
  }
}

class StepIndex {
  static const int CHECKING_PERMISSION = 0;
  static const int CHECKING_SERVICES = 1;
  static const int UPDATING_STATE = 2;
}

class Status {
  String message;
  int code;
  bool visible;
  Status({@required this.message, this.code = 0, this.visible = false});
}
