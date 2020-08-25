import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthenticationData extends Equatable {
  final String organizationID;
  final String username;
  final String token;
  final DateTime issuingDate;

  AuthenticationData({
    @required this.organizationID,
    @required this.username,
    @required this.token,
    @required this.issuingDate,
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
    final issuingDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(json['issuingDate']));
    if (username == null ||
        token == null ||
        organizationID == null ||
        issuingDate == null) {
      throw FormatException();
    }
    return AuthenticationData(
      organizationID: organizationID,
      username: username,
      token: token,
      issuingDate: issuingDate,
    );
  }

  @override
  List<Object> get props => [username, token, organizationID, issuingDate];
}
