import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../widgets/circular_progress_indicator_icon.dart';
import '../cubit/submit_poi_cubit.dart';

class SubmitPoiPage extends StatefulWidget implements AutoRouteWrapper {
  SubmitPoiPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubmitPoiCubit>(),
      child: this,
    );
  }

  @override
  _SubmitPoiPageState createState() => _SubmitPoiPageState();
}

class _SubmitPoiPageState extends State<SubmitPoiPage> {
  final _formKey = GlobalKey<FormState>();
  final Color _alphaColor = const Color.fromARGB(128, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.bloc<SubmitPoiCubit>().capture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitPoiCubit, SubmitPoiState>(
      listener: (context, state) {
        if (state.status == SubmitPoiStatus.submitSuccess ||
            state.status == SubmitPoiStatus.captureFailure) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
                child: BlocBuilder<SubmitPoiCubit, SubmitPoiState>(
                  builder: (context, state) {
                    if (state.imagePath != '') {
                      final image = FileImage(File(state.imagePath));
                      return Stack(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FullScreenImagePreview(image: image);
                                  },
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'preview',
                              child: Image(image: image),
                            ),
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
                        suffixIcon: BlocBuilder<SubmitPoiCubit, SubmitPoiState>(
                          builder: (context, state) {
                            if (state.status ==
                                SubmitPoiStatus.submitInProgress) {
                              return CircularProgressIndicatorIcon(size: 2);
                            }
                            return IconButton(
                              onPressed: _submit,
                              icon: Icon(Icons.send),
                            );
                          },
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
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      print('POI submitted');
      context.bloc<SubmitPoiCubit>().submit();
    }
  }
}

class FullScreenImagePreview extends StatelessWidget {
  final FileImage image;
  const FullScreenImagePreview({Key key, @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: PhotoView(
            imageProvider: image,
            heroAttributes: PhotoViewHeroAttributes(tag: 'preview'),
          ),
        ),
      ),
    );
  }
}
