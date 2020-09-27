import 'package:flutter/material.dart';

class PopupAction {
  const PopupAction({@required this.onPressed, @required this.child});

  final VoidCallback onPressed;
  final Widget child;
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key key, @required this.actions}) : super(key: key);

  final Map<int, PopupAction> actions;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        actions[value].onPressed();
      },
      itemBuilder: (BuildContext context) => List<PopupMenuEntry>.from(
          actions.entries.map((MapEntry<int, PopupAction> e) =>
              PopupMenuItem<int>(value: e.key, child: e.value.child))),
    );
  }
}
