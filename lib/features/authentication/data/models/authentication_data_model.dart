import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:flutter/material.dart';

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
