import 'package:flutter/material.dart';

import '../../domain/entities/organizations.dart';

class OrganizationCollectionModel extends OrganizationCollection {
  OrganizationCollectionModel({@required List<OrganizationModel> organizations})
      : super(organizations: organizations);
  factory OrganizationCollectionModel.fromJson(Map<String, dynamic> json) {
    List<OrganizationModel> organizationModelList;
    try {
      Iterable it = json['organizations'];
      organizationModelList = List<OrganizationModel>.from(
          it.map((el) => OrganizationModel.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return OrganizationCollectionModel(organizations: organizationModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(organizations
        .map((e) =>
            e is OrganizationModel ? e.toJson() : throw FormatException())
        .toList());
    return {
      'organizations': jsonList,
    };
  }
}

class OrganizationModel extends Organization {
  OrganizationModel({@required String id, @required String name})
      : super(id: id, name: name);

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'name': this.name};
  }
}
