import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrganizationCollection extends Equatable {
  final List<Organization> organizations;

  OrganizationCollection({
    @required this.organizations,
  });

  factory OrganizationCollection.fromJson(List<dynamic> json) {
    List<Organization> organizationModelList;
    try {
      Iterable it = json;
      organizationModelList = List<Organization>.from(
          it.map((el) => Organization.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return OrganizationCollection(organizations: organizationModelList);
  }

  List<Map<String, dynamic>> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(organizations
        .map((e) => e is Organization ? e.toJson() : throw FormatException())
        .toList());
    return jsonList;
  }

  @override
  List<Object> get props => [organizations];
}

class Organization extends Equatable {
  final String id;
  final String name;

  Organization({
    @required this.id,
    @required this.name,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'name': this.name};
  }

  @override
  List<Object> get props => [id, name];
}
