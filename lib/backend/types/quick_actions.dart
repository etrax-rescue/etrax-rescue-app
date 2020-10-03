import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'user_states.dart';

class QuickActionCollection extends Equatable {
  QuickActionCollection({
    @required this.actions,
  });

  final List<UserState> actions;

  factory QuickActionCollection.fromJson(Map<String, dynamic> json) {
    List<UserState> quickActionList;
    try {
      Iterable it = json['actions'];
      quickActionList =
          List<UserState>.from(it.map((el) => UserState.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return QuickActionCollection(actions: quickActionList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(actions
        .map((e) => e is UserState ? e.toJson() : throw FormatException())
        .toList());
    return {
      'actions': jsonList,
    };
  }

  @override
  List<Object> get props => [actions];
}
