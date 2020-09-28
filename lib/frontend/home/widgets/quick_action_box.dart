import 'package:flutter/material.dart';

import '../../../backend/types/user_states.dart';
import 'quick_action_button.dart';

class QuickActionBox extends StatefulWidget {
  QuickActionBox({Key key, @required this.actions}) : super(key: key);

  final List<UserState> actions;

  @override
  _QuickActionBoxState createState() => _QuickActionBoxState();
}

class _QuickActionBoxState extends State<QuickActionBox>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _smallLayout() {
    return MediaQuery.of(context).size.height / 3 < 3 * 48;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: _smallLayout() ? EdgeInsets.zero : EdgeInsets.only(bottom: 48),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
      child: Stack(
        clipBehavior: Clip.none,
        overflow: Overflow.visible,
        children: [
          Positioned(
            bottom: 0,
            right: -62,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: FadeTransition(
                opacity: _animation,
                child: Builder(
                  builder: (context) {
                    if (_smallLayout()) {
                      return SingleChildScrollView(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List<Widget>.from(
                            widget.actions.map(
                              (action) => ScaleTransition(
                                scale: _animation,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: QuickActionButton(action: action),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Wrap(
                      clipBehavior: Clip.none,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      spacing: 16,
                      runSpacing: 16,
                      children: List<Widget>.from(
                        widget.actions.map(
                          (action) => ScaleTransition(
                            scale: _animation,
                            child: QuickActionButton(action: action),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
