import 'package:flutter/widgets.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PersonInfo extends Equatable {
  final String name;
  final DateTime lastSeen;
  final String description;
  final int age;
  final String address;
  final String phoneNumber;

  PersonInfo({
    @required this.name,
    @required this.lastSeen,
    @required this.description,
    this.address,
    this.phoneNumber,
    this.age,
  });

  @override
  List<Object> get props =>
      [name, lastSeen, description, address, phoneNumber, age];
}
