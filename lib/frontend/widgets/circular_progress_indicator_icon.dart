import 'package:flutter/material.dart';

class CircularProgressIndicatorIcon extends StatelessWidget {
  const CircularProgressIndicatorIcon({Key key, this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? Theme.of(context).textTheme.bodyText2.fontSize,
      width: size ?? Theme.of(context).textTheme.bodyText2.fontSize,
      child: CircularProgressIndicator(),
    );
  }
}
