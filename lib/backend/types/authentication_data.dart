import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthenticationData extends Equatable {
  AuthenticationData({
    @required this.organizationID,
    @required this.username,
    @required this.token,
    @required this.issuingDate,
  });

  final String organizationID;
  final String username;
  final String token;
  final DateTime issuingDate;

  Map<String, String> generateAuthHeader() {
    return {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  factory AuthenticationData.fromJson(Map<String, dynamic> json) {
    final organizationID = json['organizationID'];
    final username = json['username'];
    final token = json['token'];

    if (username == null ||
        token == null ||
        organizationID == null ||
        json['issuingDate'] == null) {
      throw FormatException();
    }
    final issuingDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['issuingDate']),
        isUtc: true);
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
