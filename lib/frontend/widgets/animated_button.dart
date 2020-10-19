import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  AnimatedButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    @required this.selected,
    this.foregroundColor,
    this.backgroundColor,
    this.duration = kThemeAnimationDuration,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Duration duration;
  final bool selected;

  @override
  AnimatedButtonState createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.selected,
      child: GestureDetector(
        onTap: () {
          (widget.onPressed ?? () {})();
        },
        child: SizedBox(
          height: 48,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return AnimatedContainer(
                duration: widget.duration,
                curve: Curves.fastOutSlowIn,
                height: 48,
                width: widget.selected ? 48 : constraints.maxWidth,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ?? Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: AnimatedSwitcher(
                  duration: widget.duration,
                  child: widget.selected
                      ? Theme(
                          data: ThemeData(
                              accentColor: widget.foregroundColor ??
                                  Theme.of(context).scaffoldBackgroundColor),
                          child: CircularProgressIndicator())
                      : Text(widget.label,
                          style: TextStyle(
                              color: widget.foregroundColor ??
                                  Theme.of(context).scaffoldBackgroundColor)),
                  transitionBuilder: (widget, animation) {
                    return FadeTransition(opacity: animation, child: widget);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
