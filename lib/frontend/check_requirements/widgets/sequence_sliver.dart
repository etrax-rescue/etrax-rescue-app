import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/check_requirements_cubit.dart';
import 'sequence_item.dart';

class SequenceSliver extends StatelessWidget {
  const SequenceSliver({Key key, @required this.steps}) : super(key: key);

  final List<StepContent> steps;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(8),
      sliver: BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SequenceItem(
                  index: index,
                  stepContent: steps[index],
                  last: index == (state.sequence.length - 1),
                );
              },
              childCount: state.sequence.length,
            ),
          );
        },
      ),
    );
  }
}
