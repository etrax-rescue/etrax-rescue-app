import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/initialization/presentation/pages/custom_material_icons_icons.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/util/translate_error_messages.dart';
import '../../../../injection_container.dart';
import '../bloc/initialization_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/recoverable_error_display.dart';
import '../widgets/unrecoverable_error_display.dart';

enum PopupChoices {
  relink,
}

class InitializationPage extends StatelessWidget {
  const InitializationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MISSIONS),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              if (value == PopupChoices.relink) {
                ExtendedNavigator.root.pushReplacementNamed('/');
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<PopupChoices>>[
              PopupMenuItem<PopupChoices>(
                value: PopupChoices.relink,
                child: Text(S.of(context).RECONNECT),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ExtendedNavigator.root.pushReplacementNamed('/login-page');
        },
        label: Text(S.of(context).LOGOUT),
        icon: Icon(CustomMaterialIcons.logout_24px),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: buildBody(context),
    );
  }
}

BlocProvider<InitializationBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<InitializationBloc>(),
    child: BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<InitializationBloc>(context)
                .add(StartFetchingInitializationData());
          },
          child: Builder(
            builder: (BuildContext context) {
              if (state is InitializationInitial) {
                BlocProvider.of<InitializationBloc>(context)
                    .add(StartFetchingInitializationData());
              } else if (state is InitializationSuccess) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.missionCollection.missions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                              state.missionCollection.missions[index].name),
                          subtitle: Text(DateFormat('dd.MM.yyyy - HH:mm')
                              .format(state
                                  .missionCollection.missions[index].start)),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is InitializationRecoverableError) {
                return RecoverableErrorDisplay(
                  message: translateErrorMessage(context, state.messageKey),
                );
              } else if (state is InitializationUnrecoverableError) {
                return UnrecoverableErrorDisplay(
                  message: translateErrorMessage(context, state.messageKey),
                );
              }
              print(state.toString());
              return Container();
            },
          ),
        );
      },
    ),
  );
}
