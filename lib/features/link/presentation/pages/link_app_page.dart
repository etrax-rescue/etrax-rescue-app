import 'package:etrax_rescue_app/features/link/presentation/bloc/base_uri_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrax_rescue_app/injection_container.dart';

class LinkAppPage extends StatelessWidget {
  const LinkAppPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Link'),
      ),
      body: BlocProvider(
        create: (_) => sl<BaseUriBloc>(),
        child: Center(),
      ),
    );
  }
}
