// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'width_limiter.dart';

class AnimatedButtonSliver extends StatefulWidget {
  AnimatedButtonSliver({
    Key key,
    @required this.onPressed,
    @required this.label,
    @required this.selected,
    this.foregroundColor,
    this.backgroundColor,
    this.selectedColor,
    this.duration = kThemeAnimationDuration,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final Color foregroundColor;
  final Color selectedColor;
  final Color backgroundColor;
  final Duration duration;
  final bool selected;

  @override
  AnimatedButtonSliverState createState() => AnimatedButtonSliverState();
}

class AnimatedButtonSliverState extends State<AnimatedButtonSliver>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: WidthLimiter(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: IgnorePointer(
              ignoring: widget.selected,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                color: widget.backgroundColor ?? Theme.of(context).accentColor,
                onPressed: widget.onPressed ?? () {},
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: widget.duration,
                        child: widget.selected
                            ? SpinKitThreeBounce(
                                size: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .fontSize,
                                color: widget.foregroundColor ??
                                    Theme.of(context).scaffoldBackgroundColor)
                            : Text(widget.label,
                                style: TextStyle(
                                    color: widget.foregroundColor ??
                                        Theme.of(context)
                                            .scaffoldBackgroundColor)),
                        transitionBuilder: (widget, animation) {
                          return FadeTransition(
                              opacity: animation, child: widget);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
