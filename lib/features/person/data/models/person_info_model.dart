import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/person_info.dart';

class PersonInfoModel extends PersonInfo {
  PersonInfoModel({
    @required String name,
    @required DateTime lastSeen,
    @required String description,
  }) : super(name: name, lastSeen: lastSeen, description: description);

  factory PersonInfoModel.fromJson(Map<String, dynamic> json) {
    final DateTime lastSeen = DateTime.parse(json['lastSeen']);
    return PersonInfoModel(
        name: json['name'],
        lastSeen: lastSeen,
        description: json['description']);
  }
}
