import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthenticationData extends Equatable {
  final String username;
  final String token;

  AuthenticationData({
    @required this.username,
    @required this.token,
  });

  @override
  List<Object> get props => [username, token];
}
