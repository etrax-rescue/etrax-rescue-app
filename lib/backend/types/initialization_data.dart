import 'package:equatable/equatable.dart';

import 'app_configuration.dart';
import 'missions.dart';
import 'quick_actions.dart';
import 'user_roles.dart';
import 'user_states.dart';

class InitializationData extends Equatable {
  InitializationData({
    required this.appConfiguration,
    required this.missionCollection,
    required this.userStateCollection,
    required this.quickActionCollection,
    required this.userRoleCollection,
  });

  final AppConfiguration appConfiguration;
  final MissionCollection missionCollection;
  final UserStateCollection userStateCollection;
  final QuickActionCollection quickActionCollection;
  final UserRoleCollection userRoleCollection;

  factory InitializationData.fromJson(Map<String, dynamic> json) {
    final appConfiguration =
        AppConfiguration.fromJson(json['appConfiguration']);
    final missionCollection = MissionCollection.fromJson(json);
    final userRoleCollection = UserRoleCollection.fromJson(json);
    final userStateCollection = UserStateCollection.fromJson(json);
    final quickActionCollection = QuickActionCollection.fromJson(json);
    return InitializationData(
      appConfiguration: appConfiguration,
      missionCollection: missionCollection,
      userRoleCollection: userRoleCollection,
      userStateCollection: userStateCollection,
      quickActionCollection: quickActionCollection,
    );
  }

  @override
  List<Object> get props => [
        appConfiguration,
        missionCollection,
        userStateCollection,
        userRoleCollection,
        quickActionCollection,
      ];
}
