import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/base_uri_bloc.dart';
import '../widgets/appconnect_controls.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class LinkAppPage extends StatelessWidget {
  const LinkAppPage({Key key}) : super(key: key);

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

BlocProvider<BaseUriBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<BaseUriBloc>(),
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
                  BlocBuilder<BaseUriBloc, BaseUriState>(
                    builder: (context, state) {
                      if (state is BaseUriInitial) {
                        return Container();
                      } else if (state is BaseUriVerifying) {
                        return LoadingWidget();
                      } else if (state is BaseUriStored) {
                        // TODO: Maybe login page should be a widget of this page?
                        ExtendedNavigator.root
                            .pushReplacementNamed('/login-page');
                        //ExtendedNavigator.root.pushNamed('/login-page');
                        return MessageDisplay(message: 'Erfolg!');
                      } else if (state is BaseUriError) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
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
