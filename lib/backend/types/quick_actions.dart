import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class QuickActionCollection extends Equatable {
  final List<QuickAction> actions;

  QuickActionCollection({
    @required this.actions,
  });

  factory QuickActionCollection.fromJson(Map<String, dynamic> json) {
    List<QuickAction> quickActionList;
    try {
      Iterable it = json['actions'];
      quickActionList = List<QuickAction>.from(
          it.map((el) => QuickAction.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return QuickActionCollection(actions: quickActionList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(actions
        .map((e) => e is QuickAction ? e.toJson() : throw FormatException())
        .toList());
    return {
      'actions': jsonList,
    };
  }

  @override
  List<Object> get props => [actions];
}

class QuickAction extends Equatable {
  final int id;
  final String name;
  final String description;
  final int locationAccuracy;

  QuickAction({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.locationAccuracy,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) {
    return QuickAction(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name'],
        description: json['description'] == null ? '' : json['description'],
        locationAccuracy: json['locationAccuracy'] == null
            ? throw FormatException()
            : json['locationAccuracy']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'locationAccuracy': this.locationAccuracy,
    };
  }

  @override
  List<Object> get props => [id, name, description, locationAccuracy];
}
