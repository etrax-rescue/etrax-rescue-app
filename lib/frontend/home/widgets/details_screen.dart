import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Icon(
      Icons.account_circle,
      size: 72,
      color: Colors.grey,
    ));
  }
}
