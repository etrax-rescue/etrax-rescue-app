// @dart=2.9
import 'package:flutter/material.dart';

class CircularProgressIndicatorIcon extends StatelessWidget {
  const CircularProgressIndicatorIcon({
    Key key,
    this.size,
    this.color,
  }) : super(key: key);

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(accentColor: color ?? Theme.of(context).accentColor),
      child: SizedBox(
        height: size ?? Theme.of(context).textTheme.bodyText2.fontSize,
        width: size ?? Theme.of(context).textTheme.bodyText2.fontSize,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
