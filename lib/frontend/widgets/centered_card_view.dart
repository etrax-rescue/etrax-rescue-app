import 'package:etrax_rescue_app/frontend/widgets/width_limiter.dart';
import 'package:flutter/material.dart';

class CenteredCardView extends StatelessWidget {
  final Widget child;
  const CenteredCardView({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        WidthLimiter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }
}
