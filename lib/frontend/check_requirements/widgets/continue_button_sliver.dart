import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../widgets/width_limiter.dart';
import '../cubit/check_requirements_cubit.dart';

class ContinueButtonSliver extends StatelessWidget {
  const ContinueButtonSliver({Key key, @required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: WidthLimiter(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: BlocBuilder<CheckRequirementsCubit, CheckRequirementsState>(
              builder: (context, state) {
                bool enabled = state.complete;
                return AbsorbPointer(
                  absorbing: !enabled,
                  child: MaterialButton(
                    color:
                        enabled ? Theme.of(context).accentColor : Colors.grey,
                    textColor: Colors.white,
                    onPressed: onPressed,
                    child: Text(S.of(context).CONTINUE),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
