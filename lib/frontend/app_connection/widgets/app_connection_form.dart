import 'package:etrax_rescue_app/frontend/app_connection/cubit/app_connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/custom_material_icons.dart';

class AppConnectionForm extends StatefulWidget {
  AppConnectionForm({Key key}) : super(key: key);

  @override
  _AppConnectionFormState createState() => _AppConnectionFormState();
}

class _AppConnectionFormState extends State<AppConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConnectionCubit, AppConnectionState>(
      listener: (context, state) {
        if (state.connectionString != null) {
          _controller.text = state.connectionString;
          //setState(() {});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).APP_CONNECTION_HEADING,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'https://app.etrax.at',
                suffixIcon: IconButton(
                  icon: Icon(CustomMaterialIcons.qrCodeScanner),
                  onPressed: () {
                    context.bloc<AppConnectionCubit>().scanCode(
                        S.of(context).CANCEL,
                        S.of(context).FLASH_ON,
                        S.of(context).FLASH_OFF);
                  },
                ),
              ),
              validator: (val) =>
                  val.length < 1 ? S.of(context).FIELD_REQUIRED : null,
            ),
            SizedBox(height: 10),
            BlocBuilder<AppConnectionCubit, AppConnectionState>(
                builder: (context, state) {
              if (state.status == AppConnectionStatus.error) {
                return Text(
                  translateErrorMessage(context, state.messageKey),
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).accentColor),
                );
              } else if (state.status == AppConnectionStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            }),
            BlocBuilder<AppConnectionCubit, AppConnectionState>(
              builder: (context, state) {
                if (!(state.status == AppConnectionStatus.loading)) {
                  return ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textTheme: ButtonTextTheme.primary,
                      onPressed: submit,
                      child: Text(S.of(context).CONNECT),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      context.bloc<AppConnectionCubit>().submit(_controller.text);
    }
  }
}
