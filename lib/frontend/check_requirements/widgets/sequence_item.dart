// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/translate_error_messages.dart';
import '../../widgets/circular_progress_indicator_icon.dart';
import '../../widgets/width_limiter.dart';
import '../cubit/check_requirements_cubit.dart';
import 'retry_button.dart';

class StepContent {
  const StepContent({
    @required this.title,
    @required this.onRetry,
    @required this.loadingMessage,
    @required this.completeMessage,
  });

  final String title;
  final Function(BuildContext) onRetry;
  final String loadingMessage;
  final String completeMessage;
}

class SequenceItem extends StatefulWidget {
  const SequenceItem({
    Key key,
    @required this.index,
    @required this.stepContent,
    @required this.last,
  }) : super(key: key);

  final int index;
  final StepContent stepContent;
  final bool last;

  @override
  _SequenceItemState createState() => _SequenceItemState();
}

class _SequenceItemState extends State<SequenceItem> {
  Color _currentColor(StepStatus state) {
    switch (state) {
      case StepStatus.disabled:
        return Theme.of(context).disabledColor;
        break;
      case StepStatus.loading:
        break;
      case StepStatus.failure:
        return Theme.of(context).errorColor;
        break;
      case StepStatus.complete:
        break;
    }
    return Theme.of(context).primaryColor;
  }

  Widget _buildIcon(StepStatus state) {
    Widget icon = Text((widget.index + 1).toString(),
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor));
    switch (state) {
      case StepStatus.disabled:
        break;
      case StepStatus.loading:
        icon = CircularProgressIndicatorIcon(
            size: 24, color: Theme.of(context).scaffoldBackgroundColor);
        break;
      case StepStatus.failure:
        icon = Icon(Icons.warning,
            size: 20, color: Theme.of(context).scaffoldBackgroundColor);
        break;
      case StepStatus.complete:
        icon = Icon(Icons.check,
            size: 24, color: Theme.of(context).scaffoldBackgroundColor);
        break;
    }
    return icon;
  }

  Widget _buildCircle(StepStatus status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: _currentColor(status),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: _buildIcon(status),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton(StepStatus status) {
    Widget button = status == StepStatus.failure
        ? RetryButton(onPressed: widget.stepContent.onRetry)
        : SizedBox();
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: button,
      transitionBuilder: (child, animation) {
        return SizeTransition(sizeFactor: animation, child: child);
      },
    );
  }

  Widget _buildHeading(StepStatus status, String subtitle) {
    List<Widget> children = [
      Text(
        widget.stepContent.title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          color: _currentColor(status),
        ),
      ),
    ];
    if (status != StepStatus.disabled) {
      children.add(
        Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      );
    }
    return Expanded(
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: Column(
          key: ValueKey(widget.stepContent.title.hashCode),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        transitionBuilder: (widget, animation) {
          return Container(
            alignment: Alignment.centerLeft,
            child: FadeTransition(opacity: animation, child: widget),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
      builder: (context, state) {
        final status = state.sequenceStatus[widget.index];
        String subtitle;
        switch (status) {
          case StepStatus.disabled:
            break;
          case StepStatus.loading:
            subtitle = widget.stepContent.loadingMessage;
            break;
          case StepStatus.failure:
            subtitle = translateErrorMessage(context, state.messageKey);
            break;
          case StepStatus.complete:
            subtitle = widget.stepContent.completeMessage;
            break;
        }

        return WidthLimiter(
          child: Column(
            children: [
              Row(
                children: [
                  _buildCircle(status),
                  SizedBox(width: 8),
                  _buildHeading(status, subtitle),
                ],
              ),
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 18),
                margin: EdgeInsets.only(left: 16),
                decoration: widget.last
                    ? BoxDecoration()
                    : BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: status == StepStatus.disabled
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).primaryColor),
                        ),
                      ),
                padding: EdgeInsets.only(left: 20),
                child: _buildRetryButton(status),
              ),
            ],
          ),
        );
      },
    );
  }
}
