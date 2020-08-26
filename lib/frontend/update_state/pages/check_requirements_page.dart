import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/frontend/update_state/bloc/update_state_bloc.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routes/router.gr.dart';
import '../../../injection_container.dart';

class CheckRequirementsPage extends StatefulWidget implements AutoRouteWrapper {
  CheckRequirementsPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UpdateStateBloc>(),
      child: this,
    );
  }

  @override
  _CheckRequirementsPageState createState() => _CheckRequirementsPageState();
}

class _CheckRequirementsPageState extends State<CheckRequirementsPage> {
  List<String> _messages = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _messages = [S.of(context).CHECKING_PERMISSIONS];
      });
      await Future.delayed(const Duration(seconds: 2));
      _messages.add(S.of(context).CHECKING_SERVICES);
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));
      _messages.add(S.of(context).UPDATING_STATE);
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));
      ExtendedNavigator.of(context).pushAndRemoveUntil(
        Routes.homePage,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).STATE_HEADING),
      ),
      body: BlocListener<UpdateStateBloc, UpdateStateState>(
        listener: (context, state) {},
        child: Center(
          child: ListView.builder(
            itemCount: _messages.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              if (index == _messages.length - 1) {
                return ListTile(
                  title: Text(_messages[index]),
                  trailing: CircularProgressIndicator(),
                );
              } else {
                return ListTile(
                  title: Text(_messages[index]),
                  trailing: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
