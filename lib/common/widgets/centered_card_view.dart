import 'package:flutter/material.dart';

class CenteredCardView extends StatelessWidget {
  final Widget child;
  const CenteredCardView({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          alignment: Alignment.center,
          child: Card(
            child: Container(
              constraints: BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
