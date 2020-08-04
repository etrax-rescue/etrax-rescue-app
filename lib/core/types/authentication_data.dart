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

  @override
  List<Object> get props => [username, token];
}
