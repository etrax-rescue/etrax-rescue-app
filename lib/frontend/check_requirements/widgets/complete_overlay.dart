import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../cubit/check_requirements_cubit.dart';

class CompleteOverlay extends StatefulWidget {
  CompleteOverlay({Key key}) : super(key: key);

  @override
  _CompleteOverlayState createState() => _CompleteOverlayState();
}

class _CompleteOverlayState extends State<CompleteOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
      builder: (context, state) {
        if (state.complete) {
          _controller.forward();

          return FadeTransition(
            opacity: _animation,
            child: Container(
              alignment: Alignment.center,
              color: Color.fromARGB(200, 255, 255, 255),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done,
                        size: 128,
                      ),
                      Text(
                        S.of(context).OK,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
