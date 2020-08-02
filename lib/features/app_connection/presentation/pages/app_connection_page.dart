import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/background.dart';
import '../../../../common/widgets/centered_card_view.dart';
import '../../../../injection_container.dart';
import '../bloc/app_connection_bloc.dart';
import '../widgets/app_connection_form.dart';

class AppConnectionPage extends StatelessWidget {
  const AppConnectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppConnectionBloc>(),
      child: Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,
        body: Background(
          child: BlocConsumer<AppConnectionBloc, AppConnectionState>(
            listener: (context, state) {
              if (state is AppConnectionStateSuccess) {
                // Go to next page when no update is required or when the update succeeded
                ExtendedNavigator.root.popAndPush('/login-page');
              }
            },
            builder: (context, state) {
              if (state is AppConnectionInitial) {
                BlocProvider.of<AppConnectionBloc>(context)
                    .add(AppConnectionEventCheck());
                return Container();
              } else if (state is AppConnectionStateSuccess) {
                return Container();
              }
              return Center(
                child: SingleChildScrollView(
                  child: CenteredCardView(
                    child: AppConnectionForm(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
