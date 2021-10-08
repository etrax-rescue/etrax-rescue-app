// @dart=2.9
import '../../widgets/width_limiter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../bloc/missions_bloc.dart';

class TrackingInfo extends StatelessWidget {
  const TrackingInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: WidthLimiter(
        child: BlocBuilder<InitializationBloc, InitializationState>(
          builder: (context, state) {
            if (state.initializationData != null) {
              final trackingStates = state
                  .initializationData.userStateCollection.states
                  .where((s) => s.locationAccuracy > 0);
              if (trackingStates.length > 0) {
                return Theme(
                  data: Theme.of(context)
                      .copyWith(accentColor: Theme.of(context).primaryColor),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    leading: Icon(Icons.info),
                    title: Text(S.of(context).TRACKING_INFO),
                    childrenPadding: EdgeInsets.all(16),
                    children: [
                      Text(S.of(context).ORGANIZATION_TRACKING),
                    ]..addAll(List<Widget>.from(trackingStates
                        .map((s) => BulletItem(text: s.name))
                        .toList())),
                  ),
                );
              }
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

class BulletItem extends StatelessWidget {
  const BulletItem({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 6),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
