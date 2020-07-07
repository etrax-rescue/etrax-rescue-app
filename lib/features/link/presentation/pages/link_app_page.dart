import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/base_uri_bloc.dart';

class LinkAppPage extends StatelessWidget {
  const LinkAppPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Link'),
      ),
      body: buildBody(context),
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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LinkAppPageControls extends StatefulWidget {
  LinkAppPageControls({Key key}) : super(key: key);

  @override
  _LinkAppPageControlsState createState() => _LinkAppPageControlsState();
}

class _LinkAppPageControlsState extends State<LinkAppPageControls> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text('https://'),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'etrax.at/appdata',
                ),
                onChanged: (value) {
                  inputStr = value;
                },
                onSubmitted: (_) {
                  submit();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text('Link'),
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
            onPressed: submit,
          ),
        ),
      ],
    );
  }

  void submit() {
    if (inputStr == '') {
      return;
    }
    controller.clear();
    BlocProvider.of<BaseUriBloc>(context)
        .add((StoreBaseUri(uriString: 'https://' + inputStr)));
  }
}
