import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginData extends Equatable {
  LoginData({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}
