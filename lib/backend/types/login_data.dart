import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginData extends Equatable {
  final String username;
  final String password;

  LoginData({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
