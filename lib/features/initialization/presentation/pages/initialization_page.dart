import 'package:etrax_rescue_app/features/initialization/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../injection_container.dart';
import '../bloc/initialization_bloc.dart';
import '../widgets/recoverable_error_display.dart';
import '../widgets/unrecoverable_error_display.dart';

class InitializationPage extends StatelessWidget {
  const InitializationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: buildBody(context),
        ),
      ),
    );
  }
}

BlocProvider<InitializationBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<InitializationBloc>(),
    child: Container(
      constraints: BoxConstraints(maxWidth: 450),
      child: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          Center(
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: BlocBuilder<InitializationBloc, InitializationState>(
                      builder: (context, state) {
                        if (state is InitializationInitial) {
                          BlocProvider.of<InitializationBloc>(context)
                              .add(StartFetchingInitializationData());
                        } else if (state is InitializationFetching) {
                          return LoadingWidget();
                        } else if (state is InitializationSuccess) {
                          // TODO: implement go to dashboard page
                          return Text(
                            'Done!',
                          );
                          //ExtendedNavigator.root.pushReplacementNamed('/login-page');
                        } else if (state is InitializationRecoverableError) {
                          return RecoverableErrorDisplay(
                            message: translateErrorMessage(
                                context, state.messageKey),
                          );
                        } else if (state is InitializationUnrecoverableError) {
                          return UnrecoverableErrorDisplay(
                            message: translateErrorMessage(
                                context, state.messageKey),
                          );
                        }
                        print(state.toString());
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
