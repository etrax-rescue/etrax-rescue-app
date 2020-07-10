import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/base_uri_bloc.dart';
import '../widgets/link_app_page_controls.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class LinkAppPage extends StatelessWidget {
  const LinkAppPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Link'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
}

BlocProvider<BaseUriBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<BaseUriBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            BlocBuilder<BaseUriBloc, BaseUriState>(
              builder: (context, state) {
                if (state is BaseUriInitial) {
                  return MessageDisplay(
                    message: 'Link eines eTrax|rescue servers eingeben:',
                  );
                } else if (state is BaseUriVerifying) {
                  return LoadingWidget();
                } else if (state is BaseUriStored) {
                  // TODO: Maybe login page should be a widget of this page?
                  ExtendedNavigator.root.pushNamed('/login-page');
                  return MessageDisplay(message: 'Erfolg!');
                } else if (state is BaseUriError) {
                  return MessageDisplay(
                    message: state.message,
                  );
                }
              },
            ),
            SizedBox(height: 10),
            LinkAppPageControls(),
          ],
        ),
      ),
    ),
  );
}
