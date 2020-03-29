import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/person_info.dart';

class PersonInfoModel extends PersonInfo {
  PersonInfoModel({
    @required String name,
    @required DateTime lastSeen,
    @required String description,
  }) : super(name: name, lastSeen: lastSeen, description: description);

  factory PersonInfoModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final DateTime lastSeen = DateTime.parse(json['lastSeen']);
    final description = json['description'];
    if (name == null || description == null) {
      throw FormatException();
    }
    return PersonInfoModel(
        name: name, lastSeen: lastSeen, description: description);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastSeen': DateFormat('yyyy-MM-ddThh:mm:ss').format(lastSeen),
      'description': description,
    };
  }
}
