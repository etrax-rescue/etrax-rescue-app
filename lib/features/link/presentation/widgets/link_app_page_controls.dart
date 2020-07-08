import 'package:etrax_rescue_app/features/link/presentation/bloc/base_uri_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkAppPageControls extends StatefulWidget {
  LinkAppPageControls({Key key}) : super(key: key);

  @override
  _LinkAppPageControlsState createState() => _LinkAppPageControlsState();
}

class _LinkAppPageControlsState extends State<LinkAppPageControls> {
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
    if (inputStr == '' || inputStr == null) {
      return;
    }
    BlocProvider.of<BaseUriBloc>(context)
        .add((StoreBaseUri(uriString: 'https://' + inputStr)));
  }
}
