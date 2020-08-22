import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthenticationData extends Equatable {
  final String organizationID;
  final String username;
  final String token;

  AuthenticationData({
    @required this.organizationID,
    @required this.username,
    @required this.token,
  });

  Map<String, String> generateAuthHeader() {
    final authString =
        base64.encode(utf8.encode('$organizationID-$username:$token'));
    return {HttpHeaders.authorizationHeader: 'Basic $authString'};
  }

  factory AuthenticationData.fromJson(Map<String, dynamic> json) {
    final organizationID = json['organizationID'];
    final username = json['username'];
    final token = json['token'];
    if (username == null || token == null || organizationID == null) {
      throw FormatException();
    }
    return AuthenticationData(
        organizationID: organizationID, username: username, token: token);
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationID': this.organizationID,
      'username': this.username,
      'token': this.token,
    };
  }

  @override
  List<Object> get props => [username, token];
}
