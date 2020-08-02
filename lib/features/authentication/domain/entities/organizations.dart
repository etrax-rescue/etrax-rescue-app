import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrganizationCollection extends Equatable {
  final List<Organization> organizations;

  OrganizationCollection({
    @required this.organizations,
  });

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

  @override
  List<Object> get props => [id, name];
}
