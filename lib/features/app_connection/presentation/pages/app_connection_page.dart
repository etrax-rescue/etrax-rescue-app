import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/app_connection_bloc.dart';
import '../widgets/app_connection_controls.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class AppConnectionPage extends StatelessWidget {
  const AppConnectionPage({Key key}) : super(key: key);

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

BlocProvider<AppConnectionBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<AppConnectionBloc>(),
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Center(
          child: Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'App verbinden:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    BlocBuilder<AppConnectionBloc, AppConnectionState>(
                      builder: (context, state) {
                        if (state is AppConnectionVerifying) {
                          return LoadingWidget();
                        } else if (state is AppConnectionSuccess) {
                          ExtendedNavigator.root
                              .pushReplacementNamed('/login-page');
                          //ExtendedNavigator.root.pushNamed('/login-page');
                        } else if (state is AppConnectionError) {
                          return MessageDisplay(
                            message: state.message,
                          );
                        }
                        return Container();
                      },
                    ),
                    SizedBox(height: 10),
                    AppConnectionControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
