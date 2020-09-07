import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../util/translate_error_messages.dart';
import '../cubit/submit_poi_cubit.dart';

const Color ALPHA_COLOR = const Color.fromARGB(128, 0, 0, 0);

class SubmitPoiControls extends StatefulWidget {
  SubmitPoiControls({Key key}) : super(key: key);

  @override
  _SubmitPoiControlsState createState() => _SubmitPoiControlsState();
}

class _SubmitPoiControlsState extends State<SubmitPoiControls> {
  final _formKey = GlobalKey<FormState>();
  String _description;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomLeft,
      child: Container(
        color: ALPHA_COLOR,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: BlocBuilder<SubmitPoiCubit, SubmitPoiState>(
              builder: (context, state) {
                List<Widget> children = [
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      errorStyle: TextStyle(color: Colors.white),
                      hintText: S.of(context).POI_DESCRIPTION,
                      suffixIcon: !(state is SubmitPoiUploading)
                          ? IconButton(
                              onPressed: _submit,
                              icon: Icon(Icons.send),
                            )
                          : SizedBox(),
                    ),
                    enabled: !(state is SubmitPoiUploading),
                    onChanged: (val) {
                      _description = val;
                    },
                    validator: (String val) {
                      return val.length < 1
                          ? S.of(context).FIELD_REQUIRED
                          : null;
                    },
                  ),
                ];
                if (state is SubmitPoiUploading) {
                  children.insert(
                    0,
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: LinearProgressIndicator(
                        minHeight:
                            Theme.of(context).textTheme.bodyText2.fontSize,
                        value: state.progress,
                      ),
                    ),
                  );
                } else if (state is SubmitPoiError) {
                  children.insert(
                    0,
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        translateErrorMessage(context, state.messageKey),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      print('POI submitted');
      context.bloc<SubmitPoiCubit>().submit(_description);
    }
  }
}
