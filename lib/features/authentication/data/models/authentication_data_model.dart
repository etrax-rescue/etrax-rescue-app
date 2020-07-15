import 'package:flutter/material.dart';

import '../../domain/entities/authentication_data.dart';

class AuthenticationDataModel extends AuthenticationData {
  AuthenticationDataModel({@required String username, @required String token})
      : super(username: username, token: token);

  factory AuthenticationDataModel.fromJson(Map<String, dynamic> json) {
    final username = json['username'];
    final token = json['token'];
    if (username == null || token == null) {
      throw FormatException();
    }
    return AuthenticationDataModel(username: username, token: token);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
      'token': this.token,
    };
  }
}
