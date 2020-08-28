import 'package:flutter/material.dart';

class WidthLimiter extends StatelessWidget {
  const WidthLimiter({@required this.child, this.maxWidth = 450});

  final int maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: 450),
        child: child,
      ),
    );
  }
}
