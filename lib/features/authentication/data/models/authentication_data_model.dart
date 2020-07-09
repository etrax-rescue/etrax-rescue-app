import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:flutter/material.dart';

class AuthenticationDataModel extends AuthenticationData {
  AuthenticationDataModel({@required String username, @required String token})
      : super(username: username, token: token);
}
