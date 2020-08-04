import 'package:flutter/material.dart';

import '../../../../core/types/authentication_data.dart';

class AuthenticationDataModel extends AuthenticationData {
  AuthenticationDataModel(
      {@required String organizationID,
      @required String username,
      @required String token})
      : super(organizationID: organizationID, username: username, token: token);

  factory AuthenticationDataModel.fromJson(Map<String, dynamic> json) {
    final organizationID = json['organizationID'];
    final username = json['username'];
    final token = json['token'];
    if (username == null || token == null || organizationID == null) {
      throw FormatException();
    }
    return AuthenticationDataModel(
        organizationID: organizationID, username: username, token: token);
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationID': this.organizationID,
      'username': this.username,
      'token': this.token,
    };
  }
}
