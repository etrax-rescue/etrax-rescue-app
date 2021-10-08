import 'dart:io';

import 'package:equatable/equatable.dart';

class AuthenticationData extends Equatable {
  AuthenticationData({
    required this.organizationID,
    required this.username,
    required this.token,
    required this.expirationDate,
  });

  final String organizationID;
  final String username;
  final String token;
  final DateTime expirationDate;

  Map<String, String> generateAuthHeader() {
    return {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  factory AuthenticationData.fromJson(Map<String, dynamic> json) {
    final organizationID = json['organization_id'];
    final username = json['username'];
    final token = json['token'];

    if (username == null ||
        token == null ||
        organizationID == null ||
        json['expiration_date'] == null) {
      throw FormatException();
    }
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['expiration_date']),
        isUtc: true);
    return AuthenticationData(
      organizationID: organizationID,
      username: username,
      token: token,
      expirationDate: expirationDate,
    );
  }

  @override
  List<Object> get props => [username, token, organizationID, expirationDate];
}
