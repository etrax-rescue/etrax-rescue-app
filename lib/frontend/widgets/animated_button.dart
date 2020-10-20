import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnimatedButton extends StatefulWidget {
  AnimatedButton({
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
  AnimatedButtonState createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return IgnorePointer(
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
                        size: Theme.of(context).textTheme.bodyText2.fontSize,
                        color: widget.foregroundColor ??
                            Theme.of(context).scaffoldBackgroundColor)
                    : Text(widget.label,
                        style: TextStyle(
                            color: widget.foregroundColor ??
                                Theme.of(context).scaffoldBackgroundColor)),
                transitionBuilder: (widget, animation) {
                  return FadeTransition(opacity: animation, child: widget);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
