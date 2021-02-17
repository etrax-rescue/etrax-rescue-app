import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../themes.dart';
import '../cubit/submit_poi_cubit.dart';
import '../widgets/image_view.dart';
import '../widgets/submit_poi_controls.dart';
import '../widgets/success_overlay.dart';

const Color ALPHA_COLOR = const Color.fromARGB(128, 0, 0, 0);

class SubmitPoiPage extends StatefulWidget implements AutoRouteWrapper {
  SubmitPoiPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: themeData[AppTheme.Black],
      child: BlocProvider(
        create: (_) => sl<SubmitPoiCubit>(),
        child: this,
      ),
    );
  }

  @override
  _SubmitPoiPageState createState() => _SubmitPoiPageState();
}

class _SubmitPoiPageState extends State<SubmitPoiPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmitPoiCubit>().capture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(S.of(context).SUBMIT_POI),
        backgroundColor: ALPHA_COLOR,
      ),
      body: BlocListener<SubmitPoiCubit, SubmitPoiState>(
        listener: (context, state) {
          if (state is SubmitPoiCaptureFailure) {
            Navigator.of(context).pop();
          } else if (state is SubmitPoiSuccess) {
            delayedPop();
          }
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: BlocBuilder<SubmitPoiCubit, SubmitPoiState>(
                  builder: (context, state) {
                    if (state is SubmitPoiReady ||
                        state is SubmitPoiUploading ||
                        state is SubmitPoiError ||
                        state is SubmitPoiSuccess) {
                      final image = FileImage(File(state.imagePath));
                      return ImageView(image: image);
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
            SubmitPoiControls(),
            SuccessOverlay(),
          ],
        ),
      ),
    );
  }

  void delayedPop() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }
}
