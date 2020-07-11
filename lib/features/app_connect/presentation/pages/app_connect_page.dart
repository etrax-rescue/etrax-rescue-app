import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/app_connect_bloc.dart';
import '../widgets/app_connect_controls.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class AppconnectPage extends StatelessWidget {
  const AppconnectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
}

BlocProvider<AppConnectBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<AppConnectBloc>(),
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'App verbinden:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  BlocBuilder<AppConnectBloc, AppConnectState>(
                    builder: (context, state) {
                      if (state is AppConnectVerifying) {
                        return LoadingWidget();
                      } else if (state is AppConnectStored) {
                        ExtendedNavigator.root
                            .pushReplacementNamed('/login-page');
                        //ExtendedNavigator.root.pushNamed('/login-page');
                      } else if (state is AppConnectError) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: 10),
                  AppconnectControls(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
