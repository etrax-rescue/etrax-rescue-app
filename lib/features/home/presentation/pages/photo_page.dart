import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/l10n.dart';

class SubmitImagePage extends StatefulWidget {
  SubmitImagePage({Key key}) : super(key: key);
  @override
  _SubmitImagePageState createState() => _SubmitImagePageState();
}

class _SubmitImagePageState extends State<SubmitImagePage> {
  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final Color _alphaColor = const Color.fromARGB(128, 0, 0, 0);
  Completer<File> _imageCompleter = Completer<File>();

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  void pickImage() async {
    PickedFile pickedFile =
        await _imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (imageFile == null) {
        Navigator.of(context).pop();
      }
      _imageCompleter.complete(imageFile);
    } else {
      Navigator.of(context).pop();
    }
  }

  void submitPOI() {
    if (_formKey.currentState.validate()) {
      print('POI submitted');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(S.of(context).SUBMIT_POI),
        backgroundColor: _alphaColor,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: FutureBuilder<File>(
                future: _imageCompleter.future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        Image.file(
                          snapshot.data,
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
            child: Container(
              color: _alphaColor,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: S.of(context).POI_DESCRIPTION,
                      suffixIcon: IconButton(
                        onPressed: submitPOI,
                        icon: Icon(Icons.send),
                      ),
                    ),
                    validator: (String val) {
                      return val.length < 1
                          ? S.of(context).FIELD_REQUIRED
                          : null;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
