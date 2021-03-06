import 'package:flutter/material.dart';

class WidthLimiter extends StatelessWidget {
  const WidthLimiter({
    @required this.child,
    this.maxWidth = 450,
    this.alignment = Alignment.center,
  });

  final double maxWidth;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: alignment,
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
